import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_bro/models/workout_exercise.dart';
import 'package:gym_bro/providers/workout_exercise_provider.dart';
import 'package:gym_bro/ui/screens/workout/widgets/checkbox_card.dart';
import 'package:gym_bro/ui/screens/workout/widgets/details_card.dart';
import 'package:gym_bro/ui/screens/workout/widgets/rest_timer.dart';
import 'package:gym_bro/ui/widgets/exercise_card.dart';
import 'package:gym_bro/utils/utils.dart';
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
  int currentIndex = 0;

  Future<void> _workoutDoneHandler(
    List<bool> seriesDone,
    List<WorkoutExercise> workoutExercises,
    WorkoutExerciseProvider weProvider,
  ) async {
    if (seriesDone.every((done) => done)) {
      if (currentIndex < workoutExercises.length - 1) {
        setState(() {
          currentIndex++;
          weProvider.resetSeriesDone(workoutExercises[currentIndex].series);
        });
      } else {
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
        Navigator.pop(context, widget.workoutId);
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
  }

  @override
  void initState() {
    Future.microtask(
      () => Provider.of<WorkoutExerciseProvider>(
        context,
        listen: false,
      ).getWorkoutExercises(widget.workoutId),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final WorkoutExerciseProvider weProvider =
        Provider.of<WorkoutExerciseProvider>(context);
    final List<WorkoutExercise> workoutExercises = weProvider.workoutExercises;
    final List<bool> seriesDone = weProvider.seriesDone;

    if (workoutExercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        body: Center(
          child: Text(
            "Seu treino está vazio :(",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    WorkoutExercise firstExercise = workoutExercises[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(widget.workoutName)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                              (context, value, child) =>
                                  LinearProgressIndicator(
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
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  SizedBox(
                    width: screenWidth,
                    child: Text(
                      firstExercise.exerciseName,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DetailsCard(
                        description: "Séries",
                        value: "${firstExercise.series}",
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
                        value:
                            "${Utils.formatDuration(Duration(seconds: firstExercise.restSeconds))}min",
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
                                    restTimeMs: firstExercise.restSeconds,
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
                      await _workoutDoneHandler(
                        seriesDone,
                        workoutExercises,
                        weProvider,
                      );
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
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),

            SliverReorderableList(
              itemBuilder: (context, index) {
                final exercise = workoutExercises[currentIndex + 1 + index];
                return ExerciseCard(
                  key: ValueKey(exercise.id),
                  isEditing: false,
                  index: index,
                  weId: exercise.id,
                  exerciseName: exercise.exerciseName,
                  series: exercise.series,
                  reps: exercise.repetitions,
                  weight: exercise.weight,
                  restSeconds: exercise.restSeconds,
                  exerciseSwap: () {
                    setState(() {
                      final temp = workoutExercises[currentIndex];
                      workoutExercises[currentIndex] = exercise;
                      workoutExercises[currentIndex + 1 + index] = temp;
                    });
                    weProvider.resetSeriesDone(
                      workoutExercises[currentIndex].series,
                    );
                  },
                );
              },
              itemCount: workoutExercises.length - (currentIndex + 1),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  int from = (currentIndex + 1) + oldIndex;
                  int to = (currentIndex + 1) + newIndex;
                  if (to > from) to--;
                  final item = workoutExercises.removeAt(from);
                  workoutExercises.insert(to, item);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
