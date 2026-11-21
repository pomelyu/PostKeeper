import 'package:postkeeper/data/constants.dart';
import 'package:sqflite/sqflite.dart';

import 'database_schema.dart';

/// Owns one connection. The composition root is responsible for closing it.
class PostKeeperDatabase {
  PostKeeperDatabase._(this.connection);

  static const schemaVersion = databaseSchemaVersion;
  final Database connection;

  /// Inject an FFI factory in tests; mobile uses the sqflite plugin factory.
  static Future<PostKeeperDatabase> open({
    required String path,
    DatabaseFactory? factory,
  }) async {
    final connection = await (factory ?? databaseFactory).openDatabase(
      path,
      options: createDatabaseOptions(),
    );
    try {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      await connection.insert('persons', {
        'id': myId,
        'name': '',
        'created_at': now,
        'updated_at': now,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      return PostKeeperDatabase._(connection);
    } catch (_) {
      await connection.close();
      rethrow;
    }
  }

  Future<void> close() => connection.close();
}
