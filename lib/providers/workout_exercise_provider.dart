import 'package:flutter/material.dart';
import 'package:gym_bro/database/repositories/workout_exercise_repository.dart';
import '../models/workout_exercise.dart';

class WorkoutExerciseProvider extends ChangeNotifier {
  final WorkoutExerciseRepository repository;

  List<WorkoutExercise> _weByWorkoutId = [];
  List<WorkoutExercise> get weByWorkoutId => _weByWorkoutId;

  WorkoutExerciseProvider({required this.repository});

  Future<void> getByWorkoutId(String id) async {
    final List<WorkoutExercise> we = await repository.getByWorkoutId(id);
    _weByWorkoutId = we;
    notifyListeners();
  }

  Future<void> add(WorkoutExercise item, String workoutId) async {
    await repository.create(item);
    getByWorkoutId(workoutId);
    notifyListeners();
  }

  Future<void> update(WorkoutExercise item, String workoutId) async {
    await repository.updateItem(item);
    getByWorkoutId(workoutId);
    notifyListeners();
  }

  Future<void> remove(String id, String workoutId) async {
    await repository.deleteItem(id);
    getByWorkoutId(workoutId);
    notifyListeners();
  }
}
