import 'package:flutter/material.dart';
import 'package:gym_bro/providers/workout_provider.dart';
import 'package:gym_bro/ui/screens/workout_edit/widgets/workout_edit_card.dart';
import 'package:provider/provider.dart';

class WorkoutManager extends StatelessWidget {
  const WorkoutManager({super.key});

  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;

    return Scaffold(
      appBar: AppBar(title: const Text("Editor de Treino")),
      body: ReorderableListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        onReorder: (oldIndex, newIndex) async {
          if (newIndex > oldIndex) newIndex -= 1;
          final item = workouts.removeAt(oldIndex);
          workouts.insert(newIndex, item);

          final WorkoutProvider workoutRepository =
              Provider.of<WorkoutProvider>(context, listen: false);

          for (int i = 0; i < workouts.length; i++) {
            final workout = workouts[i];
            workout.orderIndex = i;

            await workoutRepository.update(workout);
          }
        },
        children:
            workouts
                .map(
                  (workout) => WorkoutEditCard(
                    key: ValueKey(workout.id),
                    workoutName: workout.name,
                    workoutId: workout.id,
                  ),
                )
                .toList(),
      ),
    );
  }
}
