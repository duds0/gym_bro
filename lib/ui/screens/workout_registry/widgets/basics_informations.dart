import 'package:flutter/material.dart';
import 'package:gym_bro/ui/widgets/my_text_field.dart';
import 'package:gym_bro/ui/widgets/number_text_field.dart';

class BasicsInformations extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController workoutNameController;
  final TextEditingController workoutFrequencyController;

  const BasicsInformations({
    super.key,
    required this.workoutNameController,
    required this.formKey,
    required this.workoutFrequencyController,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Informações Básicas",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 8),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextField(
                  width: screenWidth * 0.6,
                  label: "Nome do Treino",
                  controller: workoutNameController,
                ),
                NumberTextField(
                  width: screenWidth * 0.2,
                  label: "Frequência",
                  controller: workoutFrequencyController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
