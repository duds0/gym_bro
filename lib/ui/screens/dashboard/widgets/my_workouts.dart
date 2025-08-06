import 'package:flutter/material.dart';
import 'package:gym_bro/providers/workout_provider.dart';
import 'package:gym_bro/ui/screens/dashboard/widgets/workout_card.dart';
import 'package:gym_bro/ui/screens/workout_edit/workout_manager.dart';
import 'package:gym_bro/ui/screens/workout_registry/workout_registry.dart';
import 'package:provider/provider.dart';

class MyWorkouts extends StatelessWidget {
  const MyWorkouts({super.key});

  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Para Essa Semana",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutManager(),
                        ),
                      ),
                  icon: Icon(Icons.edit_rounded),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutRegistry(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add_rounded, size: 32),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ReorderableListView(
            buildDefaultDragHandles: false,
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
            padding: const EdgeInsets.only(top: 4),
            children: [
              for (int i = 0; i < workouts.length; i++)
                workouts[i].frequencyThisWeek >= workouts[i].frequency
                    ? SizedBox(key: ValueKey(key))
                    : WorkoutCard(
                      key: ValueKey(workouts[i].id),
                      index: i,
                      workoutName: workouts[i].name,
                      workoutId: workouts[i].id,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
