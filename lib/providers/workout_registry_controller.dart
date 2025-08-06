import 'package:flutter/material.dart';
import 'package:gym_bro/models/workout_exercise.dart';

class WorkoutRegistryController extends ChangeNotifier {
  List<WorkoutExercise> _workoutExercises = [];

  List<WorkoutExercise> get workoutExercises => _workoutExercises;

  void increase(WorkoutExercise workoutExercise) {
    _workoutExercises.add(workoutExercise);
    notifyListeners();
  }

  void decrease(String weId) {
    _workoutExercises.removeWhere((we) => we.id == weId);
    notifyListeners();
  }

  void registrationCompleted() {
    _workoutExercises.clear();
  }

  void updateWorkoutExercises(List<WorkoutExercise> newOrder) {
    _workoutExercises.clear;
    _workoutExercises = newOrder;
    notifyListeners();
  }
}
