import 'package:flutter/material.dart';
import 'package:gym_bro/ui/screens/workout/workout_screen.dart';

class WorkoutCard extends StatelessWidget {
  final String workoutName;
  final String workoutId;
  final int index;

  const WorkoutCard({
    super.key,
    required this.workoutName,
    required this.workoutId,
    required this.index,
  });

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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReorderableDelayedDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.menu_rounded, size: 32),
                ),
              ),

              SizedBox(width: 10),
              Text(
                workoutName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => WorkoutScreen(
                        workoutId: workoutId,
                        workoutName: workoutName,
                      ),
                ),
              );
            },
            icon: Icon(Icons.chevron_right_rounded, size: 32),
          ),
        ],
      ),
    );
  }
}
