import 'package:flutter/material.dart';
import 'package:gym_bro/models/workout_exercise.dart';
import 'package:gym_bro/ui/widgets/exercise_card.dart';

// ignore: must_be_immutable
class ExercisesEdit extends StatelessWidget {
  final String workoutId;
  List<WorkoutExercise> workoutExercises;
  final Future<void> updateWe;

  ExercisesEdit({
    super.key,
    required this.workoutId,
    required this.workoutExercises,
    required this.updateWe,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
              workoutExercises.map((workoutExercise) {
                return ExerciseCard(
                  updateWe: updateWe,
                  isEditing: true,
                  workoutId: workoutExercise.workoutId,
                  exerciseName: workoutExercise.exerciseName,
                  series: workoutExercise.series,
                  reps: workoutExercise.repetitions,
                  weight: workoutExercise.weight,
                  restMinutes: workoutExercise.restMinutes,
                  weId: workoutExercise.id,
                );
              }).toList(),
        ),
      ],
    );
  }
}
