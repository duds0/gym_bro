import 'package:workmanager/workmanager.dart';

class WorkoutScheduler {
  static const String workoutResetTask = 'workout_reset_task';

  static Future<void> initializeWorkoutResetSchedule() async {
    final nextExecutionTime = _getNextMondayMidnight();

    await Workmanager().registerOneOffTask(
      workoutResetTask,
      'resetWorkoutsCallback',
      initialDelay: nextExecutionTime,
      constraints: Constraints(networkType: NetworkType.not_required),
    );
  }

  static Duration _getNextMondayMidnight() {
    final now = DateTime.now();

    int daysToAdd = (now.weekday == 1) ? 7 : (8 - now.weekday);

    final nextMonday = now.add(Duration(days: daysToAdd));
    final midnight = DateTime(
      nextMonday.year,
      nextMonday.month,
      nextMonday.day,
    );

    return midnight.difference(now);
  }
}
