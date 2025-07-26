import 'package:flutter/material.dart';
import 'package:gym_bro/database/repositories/workout_exercise_repository.dart';
import 'package:gym_bro/database/repositories/workout_repository.dart';
import 'package:gym_bro/models/workout.dart';
import 'package:gym_bro/models/workout_exercise.dart';
import 'package:gym_bro/providers/exercise_edit_controller.dart';
import 'package:gym_bro/providers/workout_exercise_provider.dart';
import 'package:gym_bro/providers/workout_provider.dart';
import 'package:gym_bro/ui/screens/workout_edit/widgets/exercises_edit.dart';
import 'package:gym_bro/ui/screens/workout_registry/widgets/basics_informations.dart';
import 'package:gym_bro/ui/screens/workout_registry/widgets/new_exercise.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class WorkoutEdit extends StatefulWidget {
  final String workoutId;

  const WorkoutEdit({super.key, required this.workoutId});

  @override
  State<WorkoutEdit> createState() => _WorkoutEditState();
}

class _WorkoutEditState extends State<WorkoutEdit> {
  List<WorkoutExercise> workoutExercises = [];

  final uuid = const Uuid();

  final _basicsInformationsFormKey = GlobalKey<FormState>();
  final _newExerciseFormKey = GlobalKey<FormState>();

  final TextEditingController _workoutNameController = TextEditingController();
  final TextEditingController _workoutFrequencyController =
      TextEditingController();

  Future<void> getWe() async {
    final we = await Provider.of<WorkoutExerciseRepository>(
      context,
      listen: false,
    ).getByWorkoutId(widget.workoutId);

    setState(() {
      workoutExercises = we;
    });
  }

  late Workout? actualWorkout;

  Future<void> getActualWorkout() async {
    final Workout? workout = await Provider.of<WorkoutRepository>(
      context,
      listen: false,
    ).getById(widget.workoutId);

    setState(() {
      actualWorkout = workout;
    });

    _workoutNameController.text = actualWorkout!.name;
    _workoutFrequencyController.text = actualWorkout!.frequency.toString();
  }

  Future<void> increaseExercise() async {
    final textControllers = Provider.of<ExerciseEditController>(
      context,
      listen: false,
    );

    final WorkoutExercise exercise = WorkoutExercise(
      id: uuid.v4(),
      workoutId: widget.workoutId,
      exerciseName: textControllers.exerciseNameController.text,
      exerciseOrderIndex: workoutExercises.length + 1,
      series: int.parse(textControllers.exerciseSeriesController.text),
      repetitions: textControllers.exerciseRepsController.text,
      weight: double.parse(textControllers.exerciseWeightController.text),
      restMinutes: double.parse(
        textControllers.exerciseRestTimeController.text,
      ),
    );

    await Provider.of<WorkoutExerciseRepository>(
      context,
      listen: false,
    ).create(exercise);

    await getWe();
  }

  Future<void> updateWorkout(BuildContext context) async {
    await Provider.of<WorkoutProvider>(context, listen: false).update(
      Workout(
        frequency: int.parse(_workoutFrequencyController.text),
        id: widget.workoutId,
        name: _workoutNameController.text,
        orderIndex: actualWorkout!.orderIndex,
        frequencyThisWeek: actualWorkout!.frequencyThisWeek,
      ),
    );
  }

  Future<void> updateWe() async {
    await getWe();
  }

  @override
  void initState() {
    getActualWorkout();
    getWe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final textControllers = Provider.of<ExerciseEditController>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Editar Treino")),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          if (workoutExercises.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.grey.shade900,
                content: Text(
                  'Adicione pelo menos um exercício',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                duration: Duration(seconds: 4),
              ),
            );
          } else {
            await updateWorkout(context);
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                BasicsInformations(
                  formKey: _basicsInformationsFormKey,
                  workoutNameController: _workoutNameController,
                  workoutFrequencyController: _workoutFrequencyController,
                ),

                SizedBox(height: 40),

                NewExercise(
                  formKey: _newExerciseFormKey,
                  exerciseNameController:
                      textControllers.exerciseNameController,
                  exerciseSeriesController:
                      textControllers.exerciseSeriesController,
                  exerciseRepsController:
                      textControllers.exerciseRepsController,
                  exerciseWeightController:
                      textControllers.exerciseWeightController,
                  exerciseRestTimeController:
                      textControllers.exerciseRestTimeController,
                ),

                SizedBox(height: 32),

                InkWell(
                  onTap: () async {
                    if (textControllers.isEditing) {
                      if (_newExerciseFormKey.currentState!.validate()) {
                        final WorkoutExercise? weId =
                            await Provider.of<WorkoutExerciseRepository>(
                              context,
                              listen: false,
                            ).getById(textControllers.workoutExerciseId);
                        final int weOrderIndex = weId!.exerciseOrderIndex;

                        Provider.of<WorkoutExerciseProvider>(
                          context,
                          listen: false,
                        ).update(
                          WorkoutExercise(
                            id: textControllers.workoutExerciseId,
                            workoutId: widget.workoutId,
                            exerciseName:
                                textControllers.exerciseNameController.text,
                            exerciseOrderIndex: weOrderIndex,
                            series: int.parse(
                              textControllers.exerciseSeriesController.text,
                            ),
                            repetitions:
                                textControllers.exerciseRepsController.text,
                            weight: double.parse(
                              textControllers.exerciseWeightController.text,
                            ),
                            restMinutes: double.parse(
                              textControllers.exerciseRestTimeController.text,
                            ),
                          ),
                        );

                        textControllers.clearExerciseTextFields();
                        textControllers.setIsEditing();
                      }
                    } else {
                      if (_newExerciseFormKey.currentState!.validate()) {
                        await increaseExercise();
                        setState(() {});
                        textControllers.clearExerciseTextFields();
                      }
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
                      textControllers.isEditing
                          ? "Salvar Exercício"
                          : "Adicionar Exercício",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32),

                ExercisesEdit(
                  workoutId: widget.workoutId,
                  workoutExercises: workoutExercises,
                  updateWe: updateWe(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          if (workoutExercises.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.grey.shade900,
                content: Text(
                  'Adicione pelo menos um exercício',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                duration: Duration(seconds: 4),
              ),
            );
          } else {
            await updateWorkout(context);
            Navigator.pop(context);
          }
        },
        child: Container(
          height: 56,
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "Salvar Treino",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
