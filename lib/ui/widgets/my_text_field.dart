import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final double width;
  final String label;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.width,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo Obrigatório';
          }
          return null;
        },
        controller: controller,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
