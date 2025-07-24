import 'package:gym_bro/database/helper/helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseRepository<T> {
  final String tableName;
  final DatabaseHelper dbHelper;

  BaseRepository(this.tableName, this.dbHelper);

  Future<Database> get db async => await dbHelper.database;

  Future<int> insert(Map<String, dynamic> map) async {
    return await (await db).insert(tableName, map);
  }

  Future<int> update(String id, Map<String, dynamic> map) async {
    return await (await db).update(
      tableName,
      map,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String id) async {
    return await (await db).delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> findAll() async {
    return await (await db).query(tableName);
  }

  Future<Map<String, dynamic>?> findById(String id) async {
    final result = await (await db).query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
