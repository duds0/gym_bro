import 'package:flutter/material.dart';
import 'package:gym_bro/models/workout.dart';
import 'package:gym_bro/providers/workout_provider.dart';
import 'package:gym_bro/ui/screens/dashboard/widgets/workout_card.dart';
import 'package:gym_bro/ui/screens/workout_edit/workout_manager.dart';
import 'package:gym_bro/ui/screens/workout_registry/workout_registry.dart';
import 'package:provider/provider.dart';

class MyWorkouts extends StatefulWidget {
  const MyWorkouts({super.key});

  @override
  State<MyWorkouts> createState() => _MyWorkoutsState();
}

class _MyWorkoutsState extends State<MyWorkouts> {
  late List<Workout> _filteredWorkouts;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final allWorkouts = Provider.of<WorkoutProvider>(context).workouts;

    _filteredWorkouts =
        allWorkouts.where((w) => w.frequencyThisWeek < w.frequency).toList();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _filteredWorkouts.removeAt(oldIndex);
      _filteredWorkouts.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            onReorder: _onReorder,
            padding: const EdgeInsets.only(top: 4),
            children:
                _filteredWorkouts.map((workout) {
                  return WorkoutCard(
                    key: ValueKey(workout.id),
                    workoutName: workout.name,
                    workoutId: workout.id,
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
