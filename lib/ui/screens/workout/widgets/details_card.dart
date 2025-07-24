import 'package:flutter/material.dart';

class DetailsCard extends StatelessWidget {
  final String description;
  final String value;

  const DetailsCard({
    super.key,
    required this.description,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(description, style: TextStyle(fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
