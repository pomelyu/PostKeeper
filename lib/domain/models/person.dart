import 'package:postkeeper/constant.dart';

import './location.dart';

class Person {
  const Person({
    required this.id,
    required this.name,
    required this.locations,
  });

  final String id;
  final String name;
  final List<Location> locations;
}

final Person dummyPerson = Person(
  id: dummyPersonId,
  name: '',
  locations: [],
);
