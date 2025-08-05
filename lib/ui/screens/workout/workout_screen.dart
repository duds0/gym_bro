import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_bro/database/repositories/workout_exercise_repository.dart';
import 'package:gym_bro/database/repositories/workout_repository.dart';
import 'package:gym_bro/models/workout_exercise.dart';
import 'package:gym_bro/providers/workout_provider.dart';
import 'package:gym_bro/ui/screens/workout/widgets/checkbox_card.dart';
import 'package:gym_bro/ui/screens/workout/widgets/details_card.dart';
import 'package:gym_bro/ui/screens/workout/widgets/rest_timer.dart';
import 'package:gym_bro/ui/widgets/exercise_card.dart';
import 'package:provider/provider.dart';

class WorkoutScreen extends StatefulWidget {
  final String workoutId;
  final String workoutName;

  const WorkoutScreen({
    super.key,
    required this.workoutId,
    required this.workoutName,
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  List<WorkoutExercise> workoutExercises = [];

  int currentIndex = 0;
  late List<bool> seriesDone;

  Future<void> getWorkoutExercises() async {
    final workoutExercisesList = await Provider.of<WorkoutExerciseRepository>(
      context,
      listen: false,
    ).getByWorkoutId(widget.workoutId);

    setState(() {
      workoutExercises = workoutExercisesList;
    });

    seriesDone = List.filled(workoutExercises.first.series, false);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final start = currentIndex + 1;

      int from = start + oldIndex;
      int to = start + newIndex;
      if (to > from) to -= 1;

      final item = workoutExercises.removeAt(from);
      workoutExercises.insert(to, item);
    });

    seriesDone = List.filled(workoutExercises[currentIndex].series, false);
  }

  @override
  void initState() {
    getWorkoutExercises();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (workoutExercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        body: SizedBox(),
      );
    }

    WorkoutExercise firstExercise = workoutExercises[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(widget.workoutName)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: (currentIndex + 1) / workoutExercises.length,
                      ),
                      duration: Duration(milliseconds: 500),
                      builder:
                          (context, value, child) => LinearProgressIndicator(
                            value: value,
                            backgroundColor: Colors.grey.shade800,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "${currentIndex + 1}/${workoutExercises.length}",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 8),
              SizedBox(
                width: screenWidth,
                child: Text(
                  firstExercise.exerciseName,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DetailsCard(
                    description: "Séries",
                    value: firstExercise.series.toString(),
                  ),
                  DetailsCard(
                    description: "Repetições",
                    value: firstExercise.repetitions,
                  ),
                  DetailsCard(
                    description: "Peso",
                    value: "${firstExercise.weight}Kg",
                  ),
                  DetailsCard(
                    description: "Descanso",
                    value: "${firstExercise.restMinutes}min",
                  ),
                ],
              ),
              SizedBox(height: 24),
              Column(
                children: List.generate(
                  firstExercise.series,
                  (index) => CheckboxCard(
                    serie: index + 1,
                    reps: firstExercise.repetitions,
                    weight: firstExercise.weight,
                    isDone: seriesDone[index],
                    onChanged: (value) async {
                      setState(() {
                        seriesDone[index] = value!;
                      });

                      if (value == true) {
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder:
                              (_) => RestTimer(
                                restMinutes: firstExercise.restMinutes,
                              ),
                        );
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  if (seriesDone.every((done) => done)) {
                    if (currentIndex < workoutExercises.length - 1) {
                      setState(() {
                        currentIndex++;
                        seriesDone = List.filled(
                          workoutExercises[currentIndex].series,
                          false,
                        );
                      });
                    } else {
                      final actualWorkout =
                          await Provider.of<WorkoutRepository>(
                            context,
                            listen: false,
                          ).getById(widget.workoutId);

                      actualWorkout!.frequencyThisWeek += 1;

                      await Provider.of<WorkoutProvider>(
                        context,
                        listen: false,
                      ).update(actualWorkout);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.grey.shade900,
                          content: Text(
                            'Treino concluído!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.grey.shade900,
                        content: Text(
                          'Complete todas as séries',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: screenWidth * 0.7,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Concluir Exercício",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: screenWidth,
                child: Text(
                  "Próximos Exercícios",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 16),
              ReorderableListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                onReorder: _onReorder,
                children: [
                  for (
                    int i = currentIndex + 1;
                    i < workoutExercises.length;
                    i++
                  )
                    ExerciseCard(
                      key: ValueKey(workoutExercises[i].id),
                      isEditing: false,
                      weId: workoutExercises[i].id,
                      exerciseName: workoutExercises[i].exerciseName,
                      series: workoutExercises[i].series,
                      reps: workoutExercises[i].repetitions,
                      weight: workoutExercises[i].weight,
                      restMinutes: workoutExercises[i].restMinutes,
                      exerciseSwap: () {
                        setState(() {
                          final temp = workoutExercises[currentIndex];
                          workoutExercises[currentIndex] = workoutExercises[i];
                          workoutExercises[i] = temp;
                        });

                        seriesDone = List.filled(
                          workoutExercises[currentIndex].series,
                          false,
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
