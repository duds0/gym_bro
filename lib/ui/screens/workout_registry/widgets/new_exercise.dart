import 'package:flutter/material.dart';
import 'package:gym_bro/providers/timer_picker_controller.dart';
import 'package:gym_bro/ui/widgets/my_text_field.dart';
import 'package:gym_bro/ui/widgets/number_text_field.dart';
import 'package:gym_bro/ui/widgets/time_picker.dart';

class NewExercise extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController exerciseNameController;
  final TextEditingController exerciseSeriesController;
  final TextEditingController exerciseRepsController;
  final TextEditingController exerciseWeightController;
  final TimerPickerController timerPickerController;

  const NewExercise({
    super.key,
    required this.exerciseNameController,
    required this.exerciseSeriesController,
    required this.exerciseRepsController,
    required this.exerciseWeightController,
    required this.timerPickerController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MyTextField(
                      width: screenWidth * 0.52,
                      label: "Nome do Exercício",
                      controller: exerciseNameController,
                    ),
                    // NumberTextField(
                    //   width: screenWidth * 0.2,
                    //   label: "Descanso",
                    //   controller: exerciseRestTimeController,
                    //   allowPoints: true,
                    // ),
                    TimePicker(
                      timerPickerController: timerPickerController,
                      width: screenWidth * 0.32,
                      timerPickerHeight: screenHeight * 0.4,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NumberTextField(
                      width: screenWidth * 0.24,
                      label: "Séries",
                      controller: exerciseSeriesController,
                    ),
                    MyTextField(
                      width: screenWidth * 0.24,
                      label: "Repetições",
                      controller: exerciseRepsController,
                      inputType: TextInputType.number,
                    ),
                    NumberTextField(
                      width: screenWidth * 0.24,
                      label: "Peso",
                      controller: exerciseWeightController,
                      allowPoints: true,
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
