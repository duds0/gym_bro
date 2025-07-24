import 'package:flutter/material.dart';

class FormattedInfo extends StatelessWidget {
  final String title;
  final String content;
  const FormattedInfo({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          "$title ",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        Text(
          content,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
