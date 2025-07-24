import 'package:flutter/material.dart';
import 'package:gym_bro/database/repositories/workout_exercise_repository.dart';
import 'package:gym_bro/database/repositories/workout_repository.dart';
import 'package:gym_bro/models/workout.dart';
import 'package:gym_bro/models/workout_exercise.dart';
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
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _exerciseSeriesController =
      TextEditingController();
  final TextEditingController _exerciseRepsController = TextEditingController();
  final TextEditingController _exerciseWeightController =
      TextEditingController();
  final TextEditingController _exerciseRestTimeController =
      TextEditingController();

  void clearExerciseTextFields() {
    _exerciseNameController.clear();
    _exerciseSeriesController.clear();
    _exerciseRepsController.clear();
    _exerciseWeightController.clear();
    _exerciseRestTimeController.clear();
  }

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
    final WorkoutExercise exercise = WorkoutExercise(
      id: uuid.v4(),
      workoutId: widget.workoutId,
      exerciseName: _exerciseNameController.text,
      exerciseOrderIndex: workoutExercises.length + 1,
      series: int.parse(_exerciseSeriesController.text),
      repetitions: _exerciseRepsController.text,
      weight: double.parse(_exerciseWeightController.text),
      restMinutes: double.parse(_exerciseRestTimeController.text),
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

    Navigator.pop(context);
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

    return Scaffold(
      appBar: AppBar(title: Text("Editar Treino")),
      body: SingleChildScrollView(
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
                exerciseRestTimeController: _exerciseRestTimeController,
              ),

              SizedBox(height: 32),

              InkWell(
                onTap: () async {
                  if (_newExerciseFormKey.currentState!.validate()) {
                    await increaseExercise();
                    setState(() {});
                    clearExerciseTextFields();
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
