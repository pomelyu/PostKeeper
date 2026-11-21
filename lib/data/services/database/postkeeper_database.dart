import 'package:sqflite/sqflite.dart';

import 'database_schema.dart';

/// Owns one connection. The composition root is responsible for closing it.
class PostKeeperDatabase {
  PostKeeperDatabase._(this.connection);

  static const schemaVersion = 1;
  final Database connection;

  /// Inject an FFI factory in tests; mobile uses the sqflite plugin factory.
  static Future<PostKeeperDatabase> open({
    required String path,
    DatabaseFactory? factory,
  }) async {
    final connection = await (factory ?? databaseFactory).openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: schemaVersion,
        singleInstance: false,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, version) async {
          final batch = db.batch();
          for (final statement in databaseSchema) {
            batch.execute(statement);
          }
          await batch.commit(noResult: true);
        },
      ),
    );
    return PostKeeperDatabase._(connection);
  }

  Future<void> close() => connection.close();
}
