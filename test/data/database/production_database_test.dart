import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:postkeeper/data/constants.dart';
import 'package:postkeeper/domain/models/location.dart';
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

  test(
    '聯絡人修改會持久儲存，刪除地址時保留共用地點資料',
    () async {
      store = await open();
      var people = SqlitePersonRepository(database: store!.connection);
      const first = Location(
        id: 'first',
        name: 'First',
        countryCode: 'TW',
        address: 'Address',
        latitude: 25,
        longitude: 121,
        googlePlaceId: 'google-first',
      );
      const second = Location(id: 'second', name: 'Second', countryCode: 'JP');
      await people.updateName(myId, '  Updated  ');
      await people.addLocation(myId, first);
      await people.addLocation(myId, second);
      await people.addLocation(myId, first);
      expect((await people.getMyInfo()).locations.map((item) => item.id), [
        'first',
        'second',
      ]);
      await store!.connection.insert('persons', {
        'id': 'friend',
        'name': 'Friend',
        'created_at': 0,
        'updated_at': 0,
      });
      await people.addLocation('friend', first);
      await store!.connection.insert('postcards', {
        'id': 'card',
        'orientation': 'landscape',
        'front_image_path': 'images/front.jpg',
        'send_from_id': first.id,
        'created_at': 0,
        'updated_at': 0,
      });
      await people.removeLocation(myId, first.id);
      expect(
        (await people.getPersonById('friend'))!.locations.single.id,
        first.id,
      );
      expect(
        await store!.connection.query(
          'locations',
          where: 'id = ?',
          whereArgs: [first.id],
        ),
        hasLength(1),
      );
      await store!.close();
      store = await open();
      people = SqlitePersonRepository(database: store!.connection);
      final person = await people.getMyInfo();
      expect(person.name, 'Updated');
      expect(person.locations.single.id, second.id);
      final shared = (await people.getPersonById('friend'))!.locations.single;
      expect(shared.googlePlaceId, first.googlePlaceId);
      expect(shared.address, first.address);
      expect(shared.latitude, first.latitude);
      await expectLater(people.updateName(myId, '  '), throwsArgumentError);
      await expectLater(
        people.addLocation(
          'missing',
          const Location(id: 'rollback', name: 'Rollback', countryCode: 'TW'),
        ),
        throwsA(anything),
      );
      expect(
        await store!.connection.query(
          'locations',
          where: 'id = ?',
          whereArgs: ['rollback'],
        ),
        isEmpty,
      );
    },
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
