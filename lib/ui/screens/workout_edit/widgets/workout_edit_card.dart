import 'package:flutter/material.dart';
import 'package:gym_bro/providers/workout_provider.dart';
import 'package:gym_bro/ui/screens/workout_edit/workout_edit.dart';
import 'package:provider/provider.dart';

class WorkoutEditCard extends StatelessWidget {
  final String workoutId;
  final String workoutName;

  const WorkoutEditCard({
    super.key,
    required this.workoutId,
    required this.workoutName,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.menu_rounded, size: 32),
              ),

              SizedBox(width: 10),
              Text(
                workoutName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () async {
                  await Provider.of<WorkoutProvider>(
                    context,
                    listen: false,
                  ).remove(workoutId);
                },
                icon: Icon(Icons.delete_rounded, color: Colors.red.shade300),
              ),
              IconButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutEdit(workoutId: workoutId),
                      ),
                    ),
                icon: Icon(Icons.chevron_right_rounded, size: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
