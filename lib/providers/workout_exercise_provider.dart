import 'package:flutter/material.dart';
import 'package:gym_bro/database/repositories/workout_exercise_repository.dart';
import '../models/workout_exercise.dart';

class WorkoutExerciseProvider extends ChangeNotifier {
  final WorkoutExerciseRepository repository;

  List<WorkoutExercise> _workoutExercises = [];
  List<WorkoutExercise> get workoutExercises => _workoutExercises;

  List<bool> _seriesDone = [];
  List<bool> get seriesDone => _seriesDone;

  WorkoutExerciseProvider({required this.repository});

  Future<void> getWorkoutExercises(String workoutId) async {
    final List<WorkoutExercise> we = await repository.getByWorkoutId(workoutId);
    _workoutExercises = we;
    resetSeriesDone(_workoutExercises.first.series);
    notifyListeners();
  }

  Future<void> add(WorkoutExercise item, String workoutId) async {
    await repository.create(item);
    getWorkoutExercises(workoutId);
    notifyListeners();
  }

  Future<void> update(WorkoutExercise item, String workoutId) async {
    await repository.updateWe(item);
    getWorkoutExercises(workoutId);
    notifyListeners();
  }

  Future<void> remove(String id, String workoutId) async {
    await repository.deleteWe(id);
    getWorkoutExercises(workoutId);
    notifyListeners();
  }

  void resetSeriesDone(int seriesQtd) {
    _seriesDone = List.filled(seriesQtd, false);
  }
}
