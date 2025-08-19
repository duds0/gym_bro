import 'package:flutter/material.dart';
import 'package:gym_bro/database/helper/helper.dart';
import 'package:gym_bro/database/repositories/workout_exercise_repository.dart';
import 'package:gym_bro/database/repositories/workout_repository.dart';
import 'package:gym_bro/providers/exercise_edit_controller.dart';
import 'package:gym_bro/providers/timer_picker_controller.dart';
import 'package:gym_bro/providers/workout_exercise_provider.dart';
import 'package:gym_bro/providers/workout_provider.dart';
import 'package:gym_bro/providers/workout_registry_controller.dart';
import 'package:gym_bro/scheduler/workout_scheduler.dart';
import 'package:gym_bro/ui/screens/dashboard/dashboard.dart';
import 'package:gym_bro/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await Utils.resetWorkouts();
      return Future.value(true);
    } catch (e) {
      print('Erro ao resetar treinos: $e');
      return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  await WorkoutScheduler.initializeWorkoutResetSchedule();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Singleton
        Provider<DatabaseHelper>(create: (_) => DatabaseHelper()),

        // Repositórios
        ProxyProvider<DatabaseHelper, WorkoutRepository>(
          update: (_, dbHelper, __) => WorkoutRepository(dbHelper),
        ),
        ProxyProvider<DatabaseHelper, WorkoutExerciseRepository>(
          update: (_, dbHelper, __) => WorkoutExerciseRepository(dbHelper),
        ),

        // "Repositórios Reativos"
        ChangeNotifierProvider<WorkoutProvider>(
          create:
              (context) => WorkoutProvider(
                repository: Provider.of<WorkoutRepository>(
                  context,
                  listen: false,
                ),
              ),
        ),
        ChangeNotifierProvider<WorkoutExerciseProvider>(
          create:
              (context) => WorkoutExerciseProvider(
                repository: Provider.of<WorkoutExerciseRepository>(
                  context,
                  listen: false,
                ),
              ),
        ),

        // Controllers Específicos
        ChangeNotifierProvider(create: (_) => WorkoutRegistryController()),
        ChangeNotifierProvider(create: (_) => ExerciseEditController()),
        ChangeNotifierProvider(create: (_) => TimerPickerController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          brightness: Brightness.dark,
          fontFamily: "Inter",
          appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
        ),
        home: Dashboard(),
      ),
    );
  }
}
