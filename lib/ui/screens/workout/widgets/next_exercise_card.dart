import 'package:flutter/material.dart';

class NextExerciseCard extends StatelessWidget {
  const NextExerciseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Supino Reto",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text("10-12 @ 14kg"),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.play_circle_outline_rounded, size: 32),
          ),
        ],
      ),
    );
  }
}
