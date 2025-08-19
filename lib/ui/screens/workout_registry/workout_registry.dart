import 'package:flutter/material.dart';
import 'package:gym_bro/database/repositories/workout_exercise_repository.dart';
import 'package:gym_bro/models/workout.dart';
import 'package:gym_bro/models/workout_exercise.dart';
import 'package:gym_bro/providers/timer_picker_controller.dart';
import 'package:gym_bro/providers/workout_exercise_provider.dart';
import 'package:gym_bro/providers/workout_provider.dart';
import 'package:gym_bro/providers/workout_registry_controller.dart';
import 'package:gym_bro/ui/screens/workout_registry/widgets/basics_informations.dart';
import 'package:gym_bro/ui/screens/workout_registry/widgets/exercises.dart';
import 'package:gym_bro/ui/screens/workout_registry/widgets/new_exercise.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class WorkoutRegistry extends StatefulWidget {
  const WorkoutRegistry({super.key});

  static const workoutUuid = Uuid();

  @override
  State<WorkoutRegistry> createState() => _WorkoutRegistryState();
}

class _WorkoutRegistryState extends State<WorkoutRegistry> {
  final _basicsInformationsFormKey = GlobalKey<FormState>();
  final _newExerciseFormKey = GlobalKey<FormState>();

  final uuid = const Uuid();

  final workoutId = WorkoutRegistry.workoutUuid.v4();

  final TextEditingController _workoutNameController = TextEditingController();
  final TextEditingController _workoutFrequencyController =
      TextEditingController();
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _exerciseSeriesController =
      TextEditingController();
  final TextEditingController _exerciseRepsController = TextEditingController();
  final TextEditingController _exerciseWeightController =
      TextEditingController();

  void clearExerciseTextFields() {
    _exerciseNameController.clear();
    _exerciseSeriesController.clear();
    _exerciseRepsController.clear();
    _exerciseWeightController.clear();
  }

  Future<void> saveWorkout(
    BuildContext context,
    List<WorkoutExercise> workoutExercise,
  ) async {
    int numOfWorkouts =
        Provider.of<WorkoutProvider>(context, listen: false).workouts.length;

    final Workout workout = Workout(
      id: workoutId,
      name: _workoutNameController.text,
      orderIndex: numOfWorkouts + 1,
      frequency: int.parse(_workoutFrequencyController.text),
      frequencyThisWeek: 0,
    );

    final workoutRepo = Provider.of<WorkoutProvider>(context, listen: false);
    final workoutExerciseRepo = Provider.of<WorkoutExerciseProvider>(
      context,
      listen: false,
    );

    await workoutRepo.add(workout);

    for (final we in workoutExercise) {
      await workoutExerciseRepo.add(we, workoutId);
    }

    Provider.of<WorkoutRegistryController>(
      context,
      listen: false,
    ).registrationCompleted();

    Navigator.pop(context);
  }

  Future<void> increaseExercise() async {
    final int restTime =
        Provider.of<TimerPickerController>(
          context,
          listen: false,
        ).timerPicked.inSeconds;

    List<WorkoutExercise> exercisesOfThisWorkout =
        await Provider.of<WorkoutExerciseRepository>(
          context,
          listen: false,
        ).getByWorkoutId(workoutId);

    int numOfExercises = exercisesOfThisWorkout.length;

    final workoutExerciseId = uuid.v4();

    Provider.of<WorkoutRegistryController>(context, listen: false).increase(
      WorkoutExercise(
        id: workoutExerciseId,
        workoutId: workoutId,
        exerciseName: _exerciseNameController.text,
        exerciseOrderIndex: numOfExercises + 1,
        series: int.parse(_exerciseSeriesController.text),
        repetitions: _exerciseRepsController.text,
        weight: double.parse(_exerciseWeightController.text),
        restSeconds: restTime,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<WorkoutExercise> workoutExercises =
        Provider.of<WorkoutRegistryController>(context).workoutExercises;

    final TimerPickerController timerPickerController =
        Provider.of<TimerPickerController>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Novo Treino")),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          Provider.of<WorkoutRegistryController>(
            context,
            listen: false,
          ).registrationCompleted();

          timerPickerController.resetTimerPicked();

          Navigator.pop(context);
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
                  exerciseNameController: _exerciseNameController,
                  exerciseSeriesController: _exerciseSeriesController,
                  exerciseRepsController: _exerciseRepsController,
                  exerciseWeightController: _exerciseWeightController,
                  timerPickerController: timerPickerController,
                ),

                SizedBox(height: 32),

                InkWell(
                  onTap: () async {
                    if (_newExerciseFormKey.currentState!.validate()) {
                      if (timerPickerController.timerPicked.inSeconds == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.grey.shade900,
                            content: Text(
                              'Defina o tempo de descanso',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            duration: Duration(seconds: 4),
                          ),
                        );
                        return;
                      }
                      await increaseExercise();
                      setState(() {});
                      clearExerciseTextFields();
                      timerPickerController.resetTimerPicked();
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
                      "Adicionar Exercício",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                Exercises(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          if (_basicsInformationsFormKey.currentState!.validate() &&
              workoutExercises.isNotEmpty) {
            await saveWorkout(context, workoutExercises);
          } else if (_basicsInformationsFormKey.currentState!.validate() &&
              workoutExercises.isEmpty) {
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
            "Criar Treino",
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
