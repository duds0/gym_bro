import 'package:flutter/material.dart';

class ExerciseEditController extends ChangeNotifier {
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _exerciseSeriesController =
      TextEditingController();
  final TextEditingController _exerciseRepsController = TextEditingController();
  final TextEditingController _exerciseWeightController =
      TextEditingController();
  final TextEditingController _exerciseRestTimeController =
      TextEditingController();
  late String _workoutExerciseId;

  bool _isEditing = false;

  TextEditingController get exerciseNameController => _exerciseNameController;
  TextEditingController get exerciseSeriesController =>
      _exerciseSeriesController;
  TextEditingController get exerciseRepsController => _exerciseRepsController;
  TextEditingController get exerciseWeightController =>
      _exerciseWeightController;
  TextEditingController get exerciseRestTimeController =>
      _exerciseRestTimeController;

  bool get isEditing => _isEditing;

  String get workoutExerciseId => _workoutExerciseId;

  void clearExerciseTextFields() {
    _exerciseNameController.clear();
    _exerciseSeriesController.clear();
    _exerciseRepsController.clear();
    _exerciseWeightController.clear();
    _exerciseRestTimeController.clear();
    _workoutExerciseId = "";
    notifyListeners();
  }

  void setIsEditing() {
    _isEditing = !_isEditing;
  }

  void setWeId(String weId) {
    _workoutExerciseId = weId;
  }
}
