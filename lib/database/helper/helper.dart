import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path;

    if (Platform.isAndroid || Platform.isIOS) {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, 'gym_bro.db');
    } else {
      path = 'gym_bro.db';
    }

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workout (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        order_index INTEGER,
        frequency INTEGER NOT NULL,
        frequency_this_week INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE workout_exercise (
        id TEXT PRIMARY KEY,
        workout_id INTEGER NOT NULL,
        exercise_name TEXT NOT NULL,
        exercise_order_index INTEGER NOT NULL,
        series INTEGER NOT NULL,
        repetitions TEXT NOT NULL,
        weight REAL,
        rest_seconds INTEGER,
        FOREIGN KEY (workout_id) REFERENCES workout(id)
      );
    ''');
  }
}
