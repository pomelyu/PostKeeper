import 'package:postkeeper/domain/models/person.dart';

abstract interface class PersonRepository {
  Future<List<Person>> getAllUsers();
  Future<Person> getMyInfo();
  Future<Person?> getPersonById(String id);
}
