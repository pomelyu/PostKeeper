import 'package:path/path.dart' as p;
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/domain/models/postcard.dart';
import 'package:postkeeper/enums.dart';
import 'package:sqflite_common/sqlite_api.dart';

/// Hydrates related models in batches inside the caller's read transaction.
class SqliteModelReader {
  const SqliteModelReader(this.db);

  final DatabaseExecutor db;

  Location location(Map<String, Object?> row) => Location(
    id: row['id'] as String,
    googlePlaceId: row['google_place_id'] as String?,
    name: row['name'] as String,
    countryCode: row['country_code'] as String? ?? '',
    address: row['address'] as String?,
    latitude: (row['latitude'] as num?)?.toDouble(),
    longitude: (row['longitude'] as num?)?.toDouble(),
  );

  Future<Map<String, Location>> locations() async => {
    for (final row in await db.query('locations'))
      row['id'] as String: location(row),
  };

  Future<Map<String, Person>> persons({
    Map<String, Location>? locationsById,
  }) async {
    final places = locationsById ?? await locations();
    final links = await db.query(
      'person_locations',
      orderBy: 'sort_order, location_id',
    );
    final addresses = <String, List<Location>>{};
    for (final row in links) {
      addresses
          .putIfAbsent(row['person_id'] as String, () => [])
          .add(places[row['location_id']]!);
    }
    return {
      for (final row in await db.query('persons', orderBy: 'id'))
        row['id'] as String: Person(
          id: row['id'] as String,
          name: row['name'] as String,
          locations: addresses[row['id']] ?? [],
        ),
    };
  }

  Future<List<Postcard>> postcards(
    List<Map<String, Object?>> rows, {
    required String imageRoot,
  }) async {
    if (rows.isEmpty) return [];
    final places = await locations();
    final people = await persons(locationsById: places);
    return [
      for (final row in rows)
        Postcard(
          id: row['id'] as String,
          title: row['title'] as String?,
          orientation: PostcardOrientation.values.byName(
            row['orientation'] as String,
          ),
          frontImagePath: imagePath(
            imageRoot,
            row['front_image_path'] as String?,
          ),
          backImagePath: imagePath(
            imageRoot,
            row['back_image_path'] as String?,
          ),
          sender: row['sender_id'] == null
              ? dummyPerson
              : people[row['sender_id']]!,
          recipient: row['recipient_id'] == null
              ? dummyPerson
              : people[row['recipient_id']]!,
          sendFrom: row['send_from_id'] == null
              ? dummyLocation
              : places[row['send_from_id']]!,
          sendTo: row['send_to_id'] == null
              ? dummyLocation
              : places[row['send_to_id']]!,
          sentAt: _date(row['sent_at']),
          receivedAt: _date(row['received_at']),
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            row['created_at'] as int,
            isUtc: true,
          ),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(
            row['updated_at'] as int,
            isUtc: true,
          ),
          notes: row['notes'] as String,
          isFavorite: row['is_favorite'] == 1,
        ),
    ];
  }

  static DateTime? _date(Object? value) =>
      value == null ? null : DateTime.parse(value as String);

  /// Paths stored in SQLite are portable POSIX paths below the image root.
  static String imagePath(String root, String? relative) {
    if (relative == null) return '';
    if (relative.isEmpty ||
        p.posix.isAbsolute(relative) ||
        relative.contains('\\') ||
        relative.split('/').contains('..') ||
        Uri.parse(relative).hasScheme) {
      throw FormatException('Invalid stored image path', relative);
    }
    return p.joinAll([root, ...relative.split('/')]);
  }
}
