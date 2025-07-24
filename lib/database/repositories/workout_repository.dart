import 'package:gym_bro/database/base/base_repository.dart';
import 'package:gym_bro/database/helper/helper.dart';
import 'package:gym_bro/models/workout.dart';

class WorkoutRepository extends BaseRepository<Workout> {
  WorkoutRepository(DatabaseHelper dbHelper) : super('workout', dbHelper);

  Future<int> create(Workout workout) => insert(workout.toMap());

  Future<List<Workout>> getAll() async {
    final maps = await findAll();
    return maps.map((e) => Workout.fromMap(e)).toList();
  }

  Future<Workout?> getById(String id) async {
    final map = await findById(id);
    return map != null ? Workout.fromMap(map) : null;
  }

  Future<int> updateWorkout(Workout workout) {
    return update(workout.id, workout.toMap());
  }

  Future<int> deleteWorkout(String id) => delete(id);
}
