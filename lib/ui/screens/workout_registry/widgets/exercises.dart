import 'package:flutter/material.dart';
import 'package:gym_bro/models/workout_exercise.dart';
import 'package:gym_bro/providers/workout_registry_controller.dart';
import 'package:gym_bro/ui/widgets/exercise_card.dart';
import 'package:provider/provider.dart';

class Exercises extends StatelessWidget {
  const Exercises({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<WorkoutExercise> workoutExercises =
        Provider.of<WorkoutRegistryController>(
          context,
          listen: false,
        ).workoutExercises;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: screenWidth,
          child: Text(
            "Exercícios",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 16),
        Column(
          children:
              workoutExercises
                  .map(
                    (workoutExercise) => ExerciseCard(
                      isEditing: false,
                      weId: workoutExercise.id,
                      workoutId: workoutExercise.workoutId,
                      exerciseName: workoutExercise.exerciseName,
                      series: workoutExercise.series,
                      reps: workoutExercise.repetitions,
                      weight: workoutExercise.weight,
                      restMinutes: workoutExercise.restMinutes,
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
