import 'package:flutter/material.dart';
import 'package:gym_bro/models/workout.dart';

class WeeklySummary extends StatelessWidget {
  final List<Workout> workouts;

  const WeeklySummary({super.key, required this.workouts});

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
    final total = workoutsQtd(workouts);
    final done = workoutsDone(workouts);
    final remaining = total - done;

    String message;

    if (total == 0) {
      message = "Seja bem vindo(a)! 👋🏻";
    } else if (remaining == 0) {
      message = "Você concluiu todos os treinos! 😮‍💨";
    } else if (remaining == 1) {
      message = "Resta apenas 1 treino, tá perto!";
    } else {
      message = "Restam $remaining treinos, vamos lá!";
    }

    return Text(message, style: TextStyle(fontWeight: FontWeight.w500));
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
                        workoutsQtd(workouts) == 0
                            ? 0
                            : workoutsDone(workouts) / workoutsQtd(workouts),

                    backgroundColor: Colors.black,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "${workoutsDone(workouts)}/${workoutsQtd(workouts)}",
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
