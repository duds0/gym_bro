import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberTextField extends StatelessWidget {
  final double width;
  final String label;
  final TextEditingController controller;
  final bool? allowPoints;

  const NumberTextField({
    super.key,
    required this.width,
    required this.label,
    required this.controller,
    this.allowPoints,
  });

  @override
  Widget build(BuildContext context) {
    final bool withPoint = allowPoints ?? false;

    return SizedBox(
      width: width,
      child: TextFormField(
        inputFormatters:
            withPoint
                ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))]
                : [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo Obrigatório';
          } else if (value == "0" || value == "0.0") {
            return 'Inválido';
          }

          if (withPoint) {
            if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
              return 'Digite um número válido';
            }
          } else {
            if (!RegExp(r'^\d+$').hasMatch(value)) {
              return 'Somente números inteiros';
            }
          }

          return null;
        },
        controller: controller,
        cursorColor: Colors.white,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
