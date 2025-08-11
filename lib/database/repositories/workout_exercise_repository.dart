import 'package:gym_bro/database/base/base_repository.dart';
import 'package:gym_bro/database/helper/helper.dart';
import 'package:gym_bro/models/workout_exercise.dart';

class WorkoutExerciseRepository extends BaseRepository<WorkoutExercise> {
  WorkoutExerciseRepository(DatabaseHelper dbHelper)
    : super('workout_exercise', dbHelper);

  Future<int> create(WorkoutExercise we) => insert(we.toMap());

  Future<List<WorkoutExercise>> getAll() async =>
      (await findAll()).map((e) => WorkoutExercise.fromMap(e)).toList();

  Future<WorkoutExercise?> getById(String id) async {
    final map = await findById(id);
    return map != null ? WorkoutExercise.fromMap(map) : null;
  }

  Future<int> updateWe(WorkoutExercise we) {
    return update(we.id, we.toMap());
  }

  Future<int> deleteWe(String id) => delete(id);

  Future<List<WorkoutExercise>> getByWorkoutId(String workoutId) async {
    final dbClient = await db;
    final maps = await dbClient.query(
      tableName,
      where: 'workout_id = ?',
      whereArgs: [workoutId],
      orderBy: 'exercise_order_index ASC',
    );

    return maps.map((e) => WorkoutExercise.fromMap(e)).toList();
  }
}
