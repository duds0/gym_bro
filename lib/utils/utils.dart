import 'package:gym_bro/database/helper/helper.dart';
import 'package:gym_bro/database/repositories/workout_repository.dart';
import 'package:gym_bro/models/workout.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class Utils {
  static Future<void> resetWorkouts() async {
    final dbHelper = DatabaseHelper();
    final List<Workout> allWorkouts =
        await WorkoutRepository(dbHelper).getAll();

    for (var workout in allWorkouts) {
      workout.frequencyThisWeek = 0;

      await WorkoutRepository(dbHelper).updateWorkout(workout);
    }
  }

  static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'gym_bro.db');

    await deleteDatabase(path);
  }
}
