import 'package:flutter/material.dart';

class TimerPickerController extends ChangeNotifier {
  Duration _timerPicked = Duration.zero;
  Duration get timerPicked => _timerPicked;

  void setTimerPicked(Duration newTime) {
    _timerPicked = newTime;
    notifyListeners();
  }

  void resetTimerPicked() {
    _timerPicked = Duration.zero;
    notifyListeners();
  }
}
