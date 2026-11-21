import 'package:flutter_test/flutter_test.dart';
import 'package:postkeeper/constant.dart';
import 'package:postkeeper/data/services/database/postkeeper_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late PostKeeperDatabase store;
  late Database db;

  setUpAll(sqfliteFfiInit);
  setUp(() async {
    store = await PostKeeperDatabase.open(
      path: inMemoryDatabasePath,
      factory: databaseFactoryFfi,
    );
    db = store.connection;
    await db.insert('persons', {
      'id': myId,
      'name': 'Me',
      'created_at': 0,
      'updated_at': 0,
    });
    await db.insert('locations', {
      'id': 'home',
      'name': 'Home',
      'country_code': 'TW',
      'created_at': 0,
      'updated_at': 0,
    });
    await db.insert('postcards', {
      'id': 'card',
      'orientation': 'landscape',
      'front_image_path': 'images/front.jpg',
      'sender_id': myId,
      'send_from_id': 'home',
      'created_at': 0,
      'updated_at': 0,
    });
    await db.insert('collections', {
      'id': 'album',
      'name': 'Album',
      'created_at': 0,
      'updated_at': 0,
    });
    await db.insert('collection_postcards', {
      'collection_id': 'album',
      'postcard_id': 'card',
    });
    await db.insert('person_locations', {
      'person_id': myId,
      'location_id': 'home',
    });
  });
  tearDown(() => store.close());

  test('本人與已被明信片引用的人物或地點不可刪除', () async {
    await expectLater(
      db.delete('persons', where: 'id = ?', whereArgs: [myId]),
      throwsA(isA<DatabaseException>()),
    );
    await expectLater(
      db.delete('locations', where: 'id = ?', whereArgs: ['home']),
      throwsA(isA<DatabaseException>()),
    );
    await db.delete('postcards');
    // The current user remains protected even without postcard references.
    await expectLater(
      db.delete('persons', where: 'id = ?', whereArgs: [myId]),
      throwsA(isA<DatabaseException>()),
    );
    await db.delete('locations');
    expect(await db.query('person_locations'), isEmpty);
  });

  test('刪除收藏夾只刪關聯，刪除明信片也會清理關聯', () async {
    await db.delete('collections');
    expect(await db.query('collection_postcards'), isEmpty);
    expect(await db.query('postcards'), hasLength(1));
    await db.insert('collections', {
      'id': 'other',
      'name': 'Other',
      'created_at': 0,
      'updated_at': 0,
    });
    await db.insert('collection_postcards', {
      'collection_id': 'other',
      'postcard_id': 'card',
    });
    await db.delete('postcards');
    expect(await db.query('collection_postcards'), isEmpty);
    expect(await db.query('collections'), hasLength(1));
  });

  test('拒絕無效的明信片外鍵、方向、布林值、日期格式與缺圖資料', () async {
    for (final change in <Map<String, Object?>>[
      {'sender_id': 'missing'},
      {'recipient_id': 'missing'},
      {'send_from_id': 'missing'},
      {'send_to_id': 'missing'},
      {'orientation': 'square'},
      {'is_favorite': 2},
      {'sent_at': '2026/01/01'},
      {'received_at': '2026/01/01'},
      {'front_image_path': null, 'back_image_path': null},
      {'front_image_path': ''},
    ]) {
      await expectLater(
        db.update('postcards', change),
        throwsA(isA<DatabaseException>()),
        reason: '$change',
      );
    }
  });

  test('拒絕錯誤國家格式、不成對或超出範圍的經緯度', () async {
    for (final change in <Map<String, Object?>>[
      {'country_code': 'tw'},
      {'country_code': 'TWN'},
      {'latitude': 25.0},
      {'longitude': 121.0},
      {'latitude': 91.0, 'longitude': 121.0},
      {'latitude': 25.0, 'longitude': 181.0},
    ]) {
      await expectLater(
        db.update('locations', change),
        throwsA(isA<DatabaseException>()),
        reason: '$change',
      );
    }
  });

  test('拒絕重複關聯、無效外鍵與空白收藏夾名稱', () async {
    await expectLater(
      db.insert('collection_postcards', {
        'collection_id': 'album',
        'postcard_id': 'card',
      }),
      throwsA(isA<DatabaseException>()),
    );
    await expectLater(
      db.insert('collection_postcards', {
        'collection_id': 'missing',
        'postcard_id': 'card',
      }),
      throwsA(isA<DatabaseException>()),
    );
    await expectLater(
      db.insert('person_locations', {'person_id': myId, 'location_id': 'home'}),
      throwsA(isA<DatabaseException>()),
    );
    await expectLater(
      db.update('person_locations', {'sort_order': -1}),
      throwsA(isA<DatabaseException>()),
    );
    await expectLater(
      db.update('collections', {'name': '   '}),
      throwsA(isA<DatabaseException>()),
    );
  });
}
