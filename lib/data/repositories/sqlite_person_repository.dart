import 'package:postkeeper/constant.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'person_repository.dart';
import 'sqlite_model_reader.dart';

class SqlitePersonRepository implements PersonRepository {
  const SqlitePersonRepository({required this.database});

  final Database database;

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
