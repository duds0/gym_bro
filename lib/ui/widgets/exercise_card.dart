import 'package:flutter/material.dart';
import 'package:gym_bro/providers/exercise_edit_controller.dart';
import 'package:gym_bro/providers/timer_picker_controller.dart';
import 'package:gym_bro/providers/workout_exercise_provider.dart';
import 'package:gym_bro/providers/workout_registry_controller.dart';
import 'package:gym_bro/ui/widgets/formatted_info.dart';
import 'package:gym_bro/utils/utils.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatelessWidget {
  final int index;
  final bool isEditing;
  final String weId;
  final String exerciseName;
  final int series;
  final String reps;
  final double weight;
  final int restSeconds;
  final String? workoutId;
  final Future<void>? updateWe;
  final void Function()? exerciseSwap;

  const ExerciseCard({
    super.key,
    required this.exerciseName,
    required this.series,
    required this.reps,
    required this.weight,
    required this.restSeconds,
    required this.weId,
    required this.isEditing,
    required this.index,
    this.workoutId,
    this.updateWe,
    this.exerciseSwap,
  });

  Widget iconController(BuildContext context) {
    if (workoutId == null && exerciseSwap != null) {
      return IconButton(
        onPressed: exerciseSwap,
        icon: Icon(Icons.swap_horiz_rounded, size: 32),
      );
    } else if (workoutId == null && isEditing == false) {
      return IconButton(
        onPressed: () {
          Provider.of<WorkoutRegistryController>(
            context,
            listen: false,
          ).decrease(weId);
        },
        icon: Icon(Icons.delete_rounded, color: Colors.red.shade300),
      );
    } else {
      final textControllers = Provider.of<ExerciseEditController>(
        context,
        listen: false,
      );

      final TimerPickerController timerPickerController =
          Provider.of<TimerPickerController>(context, listen: false);

      return Row(
        children: [
          IconButton(
            onPressed: () {
              if (!textControllers.isEditing) {
                textControllers.exerciseNameController.text = exerciseName;
                textControllers.exerciseSeriesController.text =
                    series.toString();
                textControllers.exerciseRepsController.text = reps;
                textControllers.exerciseWeightController.text =
                    weight.toString();

                timerPickerController.setTimerPicked(
                  Duration(seconds: restSeconds),
                );

                textControllers.setWeId(weId);

                textControllers.setIsEditing();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.grey.shade900,
                    content: Text(
                      'Conclua a edição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    duration: Duration(seconds: 4),
                  ),
                );
              }
            },
            icon: Icon(Icons.edit_rounded),
          ),

          IconButton(
            onPressed: () async {
              await Provider.of<WorkoutExerciseProvider>(
                context,
                listen: false,
              ).remove(weId, workoutId!);

              await updateWe;
            },
            icon: Icon(Icons.delete_rounded, color: Colors.red.shade300),
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
          ReorderableDelayedDragStartListener(
            index: index,
            child: Icon(Icons.menu_rounded, size: 32),
          ),
          SizedBox(width: 16),
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
                    FormattedInfo(
                      title: "Desc:",
                      content:
                          "${Utils.formatDuration(Duration(seconds: restSeconds))}min",
                    ),
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
