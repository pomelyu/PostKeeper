import 'package:postkeeper/domain/models/person.dart';
import 'package:postkeeper/domain/models/location.dart';

enum DeletePersonResult { deleted, referenced, notFound, protected }

abstract interface class PersonRepository {
  Future<Person> createPerson(String name);
  Future<DeletePersonResult> deletePerson(String id);
  Future<void> updateName(String id, String name);
  Future<void> removeLocation(String id, String locationId);
  Future<void> addLocation(String id, Location location);

  Future<List<Person>> getAllUsers();
  Future<Person> getMyInfo();
  Future<Person?> getPersonById(String id);
}
