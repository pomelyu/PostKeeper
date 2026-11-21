import 'package:postkeeper/constant.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'package:postkeeper/domain/models/location.dart';

import 'person_repository.dart';
import 'sqlite_model_reader.dart';

class SqlitePersonRepository implements PersonRepository {
  const SqlitePersonRepository({required this.database});

  final Database database;

  @override
  Future<void> updateName(String id, String name) async {
    if (name.trim().isEmpty) throw ArgumentError.value(name, 'name');
    final count = await database.update(
      'persons',
      {
        'name': name.trim(),
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    if (count != 1) throw StateError('Unknown person: $id');
  }

  @override
  Future<void> addLocation(String id, Location location) =>
      database.transaction((txn) async {
        final now = DateTime.now().millisecondsSinceEpoch;
        final existing = await txn.query(
          'locations',
          columns: ['id'],
          where: 'id = ?',
          whereArgs: [location.id],
        );
        if (existing.isEmpty) {
          await txn.insert('locations', {
            'id': location.id,
            'google_place_id': location.googlePlaceId,
            'name': location.name,
            'country_code': location.countryCode.isEmpty
                ? null
                : location.countryCode,
            'address': location.address,
            'latitude': location.latitude,
            'longitude': location.longitude,
            'created_at': now,
            'updated_at': now,
          });
        }
        final links = await txn.query(
          'person_locations',
          where: 'person_id = ?',
          whereArgs: [id],
          orderBy: 'sort_order DESC',
          limit: 1,
        );
        await txn.insert('person_locations', {
          'person_id': id,
          'location_id': location.id,
          'sort_order': links.isEmpty
              ? 0
              : (links.first['sort_order'] as int) + 1,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
        await txn.update(
          'persons',
          {'updated_at': now},
          where: 'id = ?',
          whereArgs: [id],
        );
      });

  @override
  Future<void> removeLocation(String id, String locationId) =>
      database.transaction((txn) async {
        await txn.delete(
          'person_locations',
          where: 'person_id = ? AND location_id = ?',
          whereArgs: [id, locationId],
        );
        await txn.update(
          'persons',
          {'updated_at': DateTime.now().millisecondsSinceEpoch},
          where: 'id = ?',
          whereArgs: [id],
        );
      });

  @override
  Future<List<Person>> getAllUsers() => database.transaction((txn) async {
    final people = await SqliteModelReader(txn).persons();
    final me = people.remove(myId);
    return [?me, ...people.values];
  });

  @override
  Future<Person?> getPersonById(String id) => database.transaction((txn) async {
    return (await SqliteModelReader(txn).persons())[id];
  });

  @override
  Future<Person> getMyInfo() async {
    final person = await getPersonById(myId);
    if (person == null) {
      throw StateError('Current user has not been initialized');
    }
    return person;
  }
}
