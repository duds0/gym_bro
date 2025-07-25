import 'package:flutter/material.dart';
import 'package:gym_bro/database/repositories/workout_exercise_repository.dart';
import 'package:gym_bro/providers/workout_registry_controller.dart';
import 'package:gym_bro/ui/widgets/formatted_info.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatelessWidget {
  final String? workoutId;
  final bool isEditing;
  final String weId;
  final String exerciseName;
  final int series;
  final String reps;
  final double weight;
  final double restMinutes;
  final Future<void>? updateWe;

  const ExerciseCard({
    super.key,
    required this.exerciseName,
    required this.series,
    required this.reps,
    required this.weight,
    required this.restMinutes,
    this.workoutId,
    required this.weId,
    required this.isEditing,
    this.updateWe,
  });

  Widget iconController(BuildContext context) {
    if (workoutId == null && isEditing == false) {
      return SizedBox();
    } else if (workoutId != null && isEditing == false) {
      return IconButton(
        onPressed: () {
          Provider.of<WorkoutRegistryController>(
            context,
            listen: false,
          ).decrease(weId);
        },
        icon: Icon(Icons.delete_rounded, color: Colors.red.shade400),
      );
    } else {
      return Row(
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit_rounded)),

          IconButton(
            onPressed: () async {
              await Provider.of<WorkoutExerciseRepository>(
                context,
                listen: false,
              ).deleteItem(weId);

              await updateWe;
            },
            icon: Icon(Icons.delete_rounded, color: Colors.red.shade400),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exerciseName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    FormattedInfo(
                      title: "Séries:",
                      content: "${series.toString()},",
                    ),
                    FormattedInfo(title: "Reps:", content: "$reps,"),
                    FormattedInfo(title: "Peso:", content: "${weight}Kg,"),
                    FormattedInfo(title: "Desc:", content: "${restMinutes}min"),
                  ],
                ),
              ],
            ),
          ),

          iconController(context),
        ],
      ),
    );
  }
}
