import 'package:flutter/material.dart';
import 'package:gym_bro/models/workout_exercise.dart';
import 'package:gym_bro/providers/workout_registry_controller.dart';
import 'package:gym_bro/ui/widgets/exercise_card.dart';
import 'package:provider/provider.dart';

class Exercises extends StatefulWidget {
  const Exercises({super.key});

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    var controller = Provider.of<WorkoutRegistryController>(context);
    List<WorkoutExercise> workoutExercises = controller.workoutExercises;

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
        workoutExercises.isEmpty
            ? SizedBox()
            : ReorderableListView(
              physics: ScrollPhysics(),
              buildDefaultDragHandles: false,
              shrinkWrap: true,
              children: [
                for (int i = 0; i < workoutExercises.length; i++)
                  ExerciseCard(
                    key: ValueKey(workoutExercises[i].id),
                    exerciseName: workoutExercises[i].exerciseName,
                    series: workoutExercises[i].series,
                    reps: workoutExercises[i].repetitions,
                    weight: workoutExercises[i].weight,
                    restSeconds: workoutExercises[i].restSeconds,
                    weId: workoutExercises[i].id,
                    isEditing: false,
                    index: i,
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = workoutExercises.removeAt(oldIndex);
                  workoutExercises.insert(newIndex, item);
                });

                for (int i = 0; i < workoutExercises.length; i++) {
                  final workoutExercise = workoutExercises[i];
                  workoutExercise.exerciseOrderIndex = i;
                }
                controller.updateWorkoutExercises(workoutExercises);
              },
            ),
      ],
    );
  }
}
