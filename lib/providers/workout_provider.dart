import 'package:flutter/material.dart';
import 'package:gym_bro/database/repositories/workout_repository.dart';
import '../models/workout.dart';

class WorkoutProvider extends ChangeNotifier {
  final WorkoutRepository repository;

  List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  WorkoutProvider({required this.repository});

  Future<void> loadAll() async {
    _workouts = await repository.getAll();

    _workouts.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    notifyListeners();
  }

  Future<void> add(Workout item) async {
    await repository.create(item);
    await loadAll();
    notifyListeners();
  }

  Future<void> update(Workout item) async {
    await repository.updateWorkout(item);
    await loadAll();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await repository.deleteWorkout(id);
    await loadAll();
    notifyListeners();
  }
}
