import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:postkeeper/data/constants.dart';
import 'package:postkeeper/data/repositories/sqlite_person_repository.dart';
import 'package:postkeeper/data/repositories/sqlite_postcard_repository.dart';
import 'package:postkeeper/data/services/database/database_schema.dart';
import 'package:postkeeper/data/services/database/postkeeper_database.dart';
import 'package:postkeeper/ui/main_view/main_view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Directory directory;
  PostKeeperDatabase? store;

  setUpAll(sqfliteFfiInit);
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('postkeeper_production_');
  });
  tearDown(() async {
    await store?.close();
    store = null;
    await directory.delete(recursive: true);
  });

  Future<PostKeeperDatabase> open() => PostKeeperDatabase.open(
    path: p.join(directory.path, 'postkeeper.sqlite'),
    factory: databaseFactoryFfi,
  );

  test('正式資料庫只建立本人，首頁 ViewModel 正常接受空明信片與收藏夾', () async {
    store = await open();
    final people = SqlitePersonRepository(database: store!.connection);
    final person = await people.getMyInfo();
    expect(person.id, myId);
    expect(person.name, isEmpty);
    expect(person.locations, isEmpty);
    expect(await people.getAllUsers(), hasLength(1));
    for (final table in [
      'locations',
      'person_locations',
      'postcards',
      'collections',
      'collection_postcards',
    ]) {
      expect(await store!.connection.query(table), isEmpty, reason: table);
    }
    final repository = SqlitePostcardRepository(
      database: store!.connection,
      imageRoot: directory.path,
    );
    final viewModel = MainViewModel(repository: repository);
    addTearDown(viewModel.dispose);
    await viewModel.initialize();
    expect(viewModel.latestSent, isNull);
    expect(viewModel.latestReceived, isNull);
    expect(viewModel.collection1!.id, favoriteCollectionId);
    expect(viewModel.collection1!.postcards, isEmpty);
    expect(viewModel.collection2!.id, receiveCollectionId);
    expect(viewModel.collection2!.postcards, isEmpty);
  });

  test('重開資料庫不覆蓋本人資料與既有明信片', () async {
    store = await open();
    final db = store!.connection;
    await db.update(
      'persons',
      {'name': 'Profile', 'created_at': 123, 'updated_at': 456},
      where: 'id = ?',
      whereArgs: [myId],
    );
    await db.insert('postcards', {
      'id': 'saved-card',
      'orientation': 'landscape',
      'front_image_path': 'images/front.jpg',
      'sender_id': myId,
      'sent_at': '2026-01-01',
      'created_at': 0,
      'updated_at': 0,
    });
    await store!.close();
    store = null;
    store = await open();
    final rows = await store!.connection.query('persons');
    expect(rows, hasLength(1));
    expect(rows.single['name'], 'Profile');
    expect(rows.single['created_at'], 123);
    expect(rows.single['updated_at'], 456);
    final cards = SqlitePostcardRepository(
      database: store!.connection,
      imageRoot: directory.path,
    );
    expect((await cards.getLatestSent())!.id, 'saved-card');
    expect(await cards.getLatestReceived(), isNull);
  });

  test('既有 schema 缺少本人時補建，不需要重建資料庫', () async {
    final raw = await databaseFactoryFfi.openDatabase(
      p.join(directory.path, 'postkeeper.sqlite'),
      options: createDatabaseOptions(),
    );
    expect(await raw.query('persons'), isEmpty);
    await raw.close();
    store = await open();
    expect(
      (await SqlitePersonRepository(
        database: store!.connection,
      ).getMyInfo()).id,
      myId,
    );
  });
}
