import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:postkeeper/data/constants.dart';
import 'package:postkeeper/data/repositories/mock.dart';
import 'package:postkeeper/data/services/database/database_schema.dart';
import 'package:postkeeper/domain/models/location.dart';
import 'package:postkeeper/domain/models/person.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Run from the project root:
/// dart run tool/create_mock_database.dart [output-directory]
Future<void> main(List<String> arguments) async {
  if (arguments.length == 1 &&
      (arguments.single == '--help' || arguments.single == '-h')) {
    stdout.writeln(
      'Usage: dart run tool/create_mock_database.dart [output-directory]',
    );
    stdout.writeln('Default output directory: tmp/mock_database');
    return;
  }
  if (arguments.length > 1 ||
      (arguments.isNotEmpty && arguments.single.startsWith('-'))) {
    stderr.writeln(
      'Usage: dart run tool/create_mock_database.dart [output-directory]',
    );
    exitCode = 64;
    return;
  }
  try {
    sqfliteFfiInit();
    final directory = Directory(
      arguments.isEmpty ? 'tmp/mock_database' : arguments.single,
    ).absolute;
    final database = await createMockDatabase(
      directory: directory,
      factory: databaseFactoryFfi,
    );
    await database.close();
    stdout.writeln('Created ${p.join(directory.path, 'postkeeper.sqlite')}');
    stdout.writeln('Images: ${p.join(directory.path, 'images')}');
  } catch (error) {
    stderr.writeln('Failed to create mock database: $error');
    exitCode = 1;
  }
}

/// Builds a real SQLite file and separate image files from the current mocks.
/// Caller owns the returned connection and the output directory.
Future<Database> createMockDatabase({
  required Directory directory,
  required DatabaseFactory factory,
}) async {
  await directory.create(recursive: true);
  final databasePath = p.join(directory.path, 'postkeeper.sqlite');
  if (await File(databasePath).exists()) {
    throw StateError(
      'Refusing to overwrite an existing database: $databasePath',
    );
  }
  final cards = (await MockPostcardRepository().getAllPostcards()).postcards;
  final people = await MockPersonRepository().getAllUsers();
  final collections = await MockPostcardRepository().getCustomCollections();
  final persons = <String, Person>{
    for (final person in people) person.id: person,
  };
  final locations = <String, Location>{};
  void addLocation(Location location) {
    if (location.id != dummyLocationId) locations[location.id] = location;
  }

  for (final card in cards) {
    for (final person in [card.sender, card.recipient]) {
      if (person.id != dummyPersonId) persons[person.id] = person;
    }
    addLocation(card.sendFrom);
    addLocation(card.sendTo);
  }
  for (final person in persons.values) {
    for (final location in person.locations) {
      addLocation(location);
    }
  }

  final imagePaths = <String, String>{};
  for (final source in {
    for (final card in cards) ...[card.frontImagePath, card.backImagePath],
  }) {
    if (source.isEmpty) continue;
    final relative = p.posix.join(
      'images',
      'postcards',
      'mock',
      p.basename(source),
    );
    final destination = File(p.join(directory.path, relative));
    await destination.parent.create(recursive: true);
    await File(source).copy(destination.path);
    imagePaths[source] = relative;
  }

  final database = await factory.openDatabase(
    databasePath,
    options: createDatabaseOptions(),
  );
  final epoch = DateTime.utc(2026, 1, 1).millisecondsSinceEpoch;
  String? date(DateTime? value) => value == null
      ? null
      : '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  try {
    await database.transaction((txn) async {
      final batch = txn.batch();
      for (final person in persons.values) {
        batch.insert('persons', {
          'id': person.id,
          'name': person.name,
          'created_at': epoch,
          'updated_at': epoch,
        });
      }
      for (final location in locations.values) {
        batch.insert('locations', {
          'id': location.id,
          'google_place_id': location.googlePlaceId,
          'name': location.name,
          'country_code': location.countryCode.isEmpty
              ? null
              : location.countryCode,
          'address': location.address,
          'latitude': location.latitude,
          'longitude': location.longitude,
          'created_at': epoch,
          'updated_at': epoch,
        });
      }
      for (final person in persons.values) {
        for (var i = 0; i < person.locations.length; i++) {
          final location = person.locations[i];
          if (location.id == dummyLocationId) continue;
          batch.insert('person_locations', {
            'person_id': person.id,
            'location_id': location.id,
            'sort_order': i,
          });
        }
      }
      for (final card in cards) {
        batch.insert('postcards', {
          'id': card.id,
          'title': card.title,
          'orientation': card.orientation.name,
          'front_image_path': imagePaths[card.frontImagePath],
          'back_image_path': imagePaths[card.backImagePath],
          'sender_id': card.sender.id == dummyPersonId ? null : card.sender.id,
          'recipient_id': card.recipient.id == dummyPersonId
              ? null
              : card.recipient.id,
          'send_from_id': card.sendFrom.id == dummyLocationId
              ? null
              : card.sendFrom.id,
          'send_to_id': card.sendTo.id == dummyLocationId
              ? null
              : card.sendTo.id,
          'sent_at': date(card.sentAt),
          'received_at': date(card.receivedAt),
          'notes': card.notes,
          'is_favorite': card.isFavorite ? 1 : 0,
          'created_at': card.createdAt.millisecondsSinceEpoch,
          'updated_at': card.updatedAt.millisecondsSinceEpoch,
        });
      }
      for (var i = 0; i < collections.length; i++) {
        final collection = collections[i];
        batch.insert('collections', {
          'id': collection.id,
          'name': collection.name,
          'created_at': epoch + i,
          'updated_at': epoch + i,
        });
        for (final card in collection.postcards) {
          batch.insert('collection_postcards', {
            'collection_id': collection.id,
            'postcard_id': card.id,
          });
        }
      }
      await batch.commit(noResult: true);
    });
    return database;
  } catch (_) {
    await database.close();
    rethrow;
  }
}
