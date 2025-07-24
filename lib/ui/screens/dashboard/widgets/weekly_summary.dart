import 'package:flutter/material.dart';
import 'package:gym_bro/models/workout.dart';

class WeeklySummary extends StatefulWidget {
  final List<Workout> workouts;

  const WeeklySummary({super.key, required this.workouts});

  @override
  State<WeeklySummary> createState() => _WeeklySummaryState();
}

class _WeeklySummaryState extends State<WeeklySummary> {
  double progressIndicator = 0;

  int workoutsQtd(List<Workout> workouts) {
    int numOfWorkouts = 0;
    for (var wo in workouts) {
      numOfWorkouts += wo.frequency;
    }
    return numOfWorkouts;
  }

  int workoutsDone(List<Workout> workouts) {
    int numOfWorkoutsDone = 0;
    for (var wo in workouts) {
      numOfWorkoutsDone += wo.frequencyThisWeek;
    }
    return numOfWorkoutsDone;
  }

  Widget congratulationsCheck() {
    if (workoutsDone(widget.workouts) >= workoutsQtd(widget.workouts)) {
      return Text(
        "Você concluiu todos os treinos",
        style: TextStyle(fontWeight: FontWeight.w500),
      );
    } else {
      return Text(
        "Restam ${workoutsQtd(widget.workouts) - workoutsDone(widget.workouts)} treinos, vamos lá!",
        style: TextStyle(fontWeight: FontWeight.w500),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[850],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Resumo Semanal",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),

          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value:
                        workoutsQtd(widget.workouts) == 0
                            ? 0
                            : workoutsDone(widget.workouts) /
                                workoutsQtd(widget.workouts),

                    backgroundColor: Colors.black,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "${workoutsDone(widget.workouts)}/${workoutsQtd(widget.workouts)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: congratulationsCheck(),
          ),
        ],
      ),
    );
  }
}
