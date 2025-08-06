import 'package:flutter/material.dart';
import 'package:gym_bro/database/repositories/workout_exercise_repository.dart';
import 'package:gym_bro/models/workout_exercise.dart';
import 'package:gym_bro/ui/widgets/exercise_card.dart';
import 'package:provider/provider.dart';

class ExercisesEdit extends StatefulWidget {
  final String workoutId;
  final Future<void> updateWe;

  const ExercisesEdit({
    super.key,
    required this.workoutId,
    required this.updateWe,
  });

  @override
  State<ExercisesEdit> createState() => _ExercisesEditState();
}

class _ExercisesEditState extends State<ExercisesEdit> {
  List<WorkoutExercise> workoutExercises = [];

  Future<void> getWe() async {
    final List<WorkoutExercise> we =
        await Provider.of<WorkoutExerciseRepository>(
          context,
          listen: false,
        ).getByWorkoutId(widget.workoutId);

    setState(() {
      workoutExercises = we;
    });
  }

  @override
  void initState() {
    getWe();
    super.initState();
  }

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
        ReorderableListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          buildDefaultDragHandles: false,
          children: [
            for (int i = 0; i < workoutExercises.length; i++)
              ExerciseCard(
                key: ValueKey(workoutExercises[i].id),
                exerciseName: workoutExercises[i].exerciseName,
                series: workoutExercises[i].series,
                reps: workoutExercises[i].repetitions,
                weight: workoutExercises[i].weight,
                restMinutes: workoutExercises[i].restMinutes,
                weId: workoutExercises[i].id,
                workoutId: workoutExercises[i].workoutId,
                updateWe: widget.updateWe,
                isEditing: true,
                index: i,
              ),
          ],
          onReorder: (int oldIndex, int newIndex) async {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = workoutExercises.removeAt(oldIndex);
              workoutExercises.insert(newIndex, item);
            });

            final workoutExerciseRepo = Provider.of<WorkoutExerciseRepository>(
              context,
              listen: false,
            );

            for (int i = 0; i < workoutExercises.length; i++) {
              final workoutExercise = workoutExercises[i];
              workoutExercise.exerciseOrderIndex = i;
            }

            for (final we in workoutExercises) {
              await workoutExerciseRepo.updateItem(we);
            }
          },
        ),
      ],
    );
  }
}
