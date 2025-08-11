import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CheckboxCard extends StatelessWidget {
  final int serie;
  final String reps;
  final double weight;
  bool isDone;
  final Function(bool?)? onChanged;

  CheckboxCard({
    super.key,
    required this.serie,
    required this.reps,
    required this.weight,
    required this.isDone,
    required this.onChanged,
  });

  final TextStyle serieIsDoneTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.lineThrough,
    fontStyle: FontStyle.italic,
  );

  final TextStyle infoIsDoneTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.lineThrough,
    fontStyle: FontStyle.italic,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                activeColor: Colors.white,
                value: isDone,
                onChanged: onChanged,
              ),
              Text(
                "$serieª Série",
                style:
                    isDone
                        ? serieIsDoneTextStyle
                        : TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            "$reps @ ${weight}Kg",
            style:
                isDone
                    ? infoIsDoneTextStyle
                    : TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
