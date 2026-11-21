import 'package:postkeeper/domain/models/location.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'saved_location_repository.dart';
import 'sqlite_model_reader.dart';

class SqliteLocationRepository implements SavedLocationRepository {
  const SqliteLocationRepository({required this.database});

  final Database database;

  @override
  Future<List<Location>> getAllLocations() async => [
    for (final row in await database.query('locations', orderBy: 'id'))
      SqliteModelReader(database).location(row),
  ];

  @override
  Future<Location?> getLocationById(String id) async {
    final rows = await database.query(
      'locations',
      where: 'id = ?',
      whereArgs: [id],
    );
    return rows.isEmpty
        ? null
        : SqliteModelReader(database).location(rows.single);
  }

  @override
  Future<List<Location>> getLocationsByGooglePlaceId(
    String googlePlaceId,
  ) async => [
    for (final row in await database.query(
      'locations',
      where: 'google_place_id = ?',
      whereArgs: [googlePlaceId],
      orderBy: 'id',
    ))
      SqliteModelReader(database).location(row),
  ];
}
