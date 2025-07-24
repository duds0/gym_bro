import 'package:flutter/material.dart';
import 'package:gym_bro/database/repositories/workout_exercise_repository.dart';
import '../models/workout_exercise.dart';

class WorkoutExerciseProvider extends ChangeNotifier {
  final WorkoutExerciseRepository repository;

  List<WorkoutExercise> _workoutExercises = [];
  List<WorkoutExercise> get workoutExercises => _workoutExercises;

  WorkoutExerciseProvider({required this.repository});

  Future<void> loadAll() async {
    _workoutExercises = await repository.getAll();
    notifyListeners();
  }

  Future<void> add(WorkoutExercise item) async {
    await repository.create(item);
    await loadAll();
    notifyListeners();
  }

  Future<void> update(WorkoutExercise item) async {
    await repository.updateItem(item);
    await loadAll();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await repository.deleteItem(id);
    await loadAll();
    notifyListeners();
  }
}
