import 'package:postkeeper/constant.dart';
import 'package:postkeeper/data/country_code.dart';
import 'package:postkeeper/domain/models/collection.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/enums.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'postcard_repository.dart';
import 'sqlite_model_reader.dart';
import 'utils.dart';

class SqlitePostcardRepository implements PostcardRepository {
  const SqlitePostcardRepository({
    required this.database,
    required this.imageRoot,
  });

  final Database database;

  /// Persistent data directory; SQLite only contains paths relative to it.
  final String imageRoot;

  Future<List<Postcard>> _read({
    String? where,
    List<Object?>? args,
    String orderBy = 'sent_at, id',
    int? limit,
  }) => database.transaction((txn) async {
    final rows = await txn.query(
      'postcards',
      where: where,
      whereArgs: args,
      orderBy: orderBy,
      limit: limit,
    );
    return SqliteModelReader(txn).postcards(rows, imageRoot: imageRoot);
  });

  Collection _system(String id, String name, List<Postcard> cards) =>
      Collection(
        id: id,
        name: name,
        type: CollectionType.system,
        postcards: cards,
      );

  @override
  Future<Collection> getAllPostcards() async =>
      _system(allCollectionId, 'All', await _read());

  @override
  Future<Collection> getAllMySent() async => _system(
    sentCollectionId,
    'My Sent',
    await _read(where: 'sender_id = ?', args: [myId]),
  );

  @override
  Future<Collection> getAllMyReceived() async => _system(
    receiveCollectionId,
    'My Received',
    await _read(where: 'recipient_id = ?', args: [myId]),
  );

  @override
  Future<Collection> getAllFavorite() async => _system(
    favoriteCollectionId,
    'Favorite',
    await _read(where: 'is_favorite = ?', args: [1]),
  );

  @override
  Future<Postcard?> getLatestSent() async {
    final rows = await _read(
      where: 'sender_id = ? AND sent_at IS NOT NULL',
      args: [myId],
      orderBy: 'sent_at DESC, id',
      limit: 1,
    );
    return rows.firstOrNull;
  }

  @override
  Future<Postcard?> getLatestReceived() async {
    final rows = await _read(
      where: 'recipient_id = ? AND received_at IS NOT NULL',
      args: [myId],
      orderBy: 'received_at DESC, id',
      limit: 1,
    );
    return rows.firstOrNull;
  }

  @override
  Future<Postcard?> getPostcardById(String id) async =>
      (await _read(where: 'id = ?', args: [id])).firstOrNull;

  @override
  Future<List<Collection>> getCollectionsByRegion() async {
    final groups = groupCardsBy(
      await _read(),
      (card) => CountryCode.getRegion(card.sendFrom.countryCode),
    );
    final keys = groups.keys.toList()..sort();
    return [
      for (final key in keys)
        Collection(
          id: key,
          name: key,
          type: CollectionType.region,
          postcards: groups[key]!,
        ),
    ];
  }

  @override
  Future<List<Collection>> getCollectionsByYear() async {
    final groups = groupCardsBy(
      await _read(),
      (card) => card.sentAt?.year.toString() ?? '000',
    );
    final keys = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final key in keys)
        Collection(
          id: key,
          name: key,
          type: CollectionType.year,
          postcards: groups[key]!,
        ),
    ];
  }

  Future<List<Collection>> _customCollections({String? id}) =>
      database.transaction((txn) async {
        final rows = await txn.query(
          'collections',
          where: id == null ? null : 'id = ?',
          whereArgs: id == null ? null : [id],
          orderBy: 'created_at, id',
        );
        if (rows.isEmpty) return [];
        final cardRows = await txn.rawQuery('''
          SELECT p.*, cp.collection_id AS member_collection_id
          FROM collection_postcards cp JOIN postcards p ON p.id = cp.postcard_id
          ${id == null ? '' : 'WHERE cp.collection_id = ?'}
          ORDER BY p.sent_at, p.id
        ''', id == null ? [] : [id]);
        final cards = await SqliteModelReader(txn)
            .postcards(cardRows, imageRoot: imageRoot);
        final members = <String, List<Postcard>>{};
        for (var i = 0; i < cards.length; i++) {
          members
              .putIfAbsent(
                cardRows[i]['member_collection_id'] as String,
                () => [],
              )
              .add(cards[i]);
        }
        return [
          for (final row in rows)
            Collection(
              id: row['id'] as String,
              name: row['name'] as String,
              type: CollectionType.custom,
              postcards: members[row['id']] ?? [],
            ),
        ];
      });

  @override
  Future<List<Collection>> getCustomCollections() => _customCollections();

  @override
  Future<Collection?> getCustomCollectionById(String id) async =>
      (await _customCollections(id: id)).firstOrNull;

  @override
  Future<List<Postcard>> searchPostcards(String query) {
    final term = query.trim();
    if (term.isEmpty) return _read();
    // Treat SQL LIKE wildcard characters as literal user input.
    final pattern =
        '%${term.replaceAll('\\', '\\\\').replaceAll('%', '\\%').replaceAll('_', '\\_')}%';
    return _read(
      where: r'''
        id IN (
          SELECT p.id FROM postcards p
          LEFT JOIN persons sender ON sender.id = p.sender_id
          LEFT JOIN persons recipient ON recipient.id = p.recipient_id
          LEFT JOIN locations origin ON origin.id = p.send_from_id
          LEFT JOIN locations destination ON destination.id = p.send_to_id
          WHERE p.title LIKE ? ESCAPE '\' OR p.notes LIKE ? ESCAPE '\'
            OR sender.name LIKE ? ESCAPE '\' OR recipient.name LIKE ? ESCAPE '\'
            OR origin.name LIKE ? ESCAPE '\' OR origin.address LIKE ? ESCAPE '\'
            OR destination.name LIKE ? ESCAPE '\' OR destination.address LIKE ? ESCAPE '\'
        )
      ''',
      args: List.filled(8, pattern),
    );
  }
}
