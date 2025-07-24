import 'package:flutter/material.dart';
import 'package:gym_bro/ui/widgets/my_text_field.dart';
import 'package:gym_bro/ui/widgets/number_text_field.dart';

class NewExercise extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController exerciseNameController;
  final TextEditingController exerciseSeriesController;
  final TextEditingController exerciseRepsController;
  final TextEditingController exerciseWeightController;
  final TextEditingController exerciseRestTimeController;

  const NewExercise({
    super.key,
    required this.exerciseNameController,
    required this.exerciseSeriesController,
    required this.exerciseRepsController,
    required this.exerciseWeightController,
    required this.exerciseRestTimeController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            width: screenWidth,
            child: Text(
              "Novo Exercício",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextField(
                      width: screenWidth * 0.6,
                      label: "Nome do Exercício",
                      controller: exerciseNameController,
                    ),
                    NumberTextField(
                      width: screenWidth * 0.2,
                      label: "Descanso",
                      controller: exerciseRestTimeController,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NumberTextField(
                      width: screenWidth * 0.24,
                      label: "Séries",
                      controller: exerciseSeriesController,
                    ),
                    NumberTextField(
                      width: screenWidth * 0.24,
                      label: "Repetições",
                      controller: exerciseRepsController,
                    ),
                    NumberTextField(
                      width: screenWidth * 0.24,
                      label: "Peso",
                      controller: exerciseWeightController,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
