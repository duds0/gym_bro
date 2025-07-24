import 'package:flutter/material.dart';
import 'package:gym_bro/models/workout.dart';
import 'package:gym_bro/providers/workout_provider.dart';
import 'package:gym_bro/ui/screens/workout_edit/widgets/workout_edit_card.dart';
import 'package:provider/provider.dart';

class WorkoutManager extends StatelessWidget {
  const WorkoutManager({super.key});

  @override
  Widget build(BuildContext context) {
    List<Workout> workouts = Provider.of<WorkoutProvider>(context).workouts;

    return Scaffold(
      appBar: AppBar(title: Text("Editor de Treino")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children:
                workouts
                    .map(
                      (workout) => WorkoutEditCard(
                        workoutId: workout.id,
                        workoutName: workout.name,
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}
