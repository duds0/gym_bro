import 'package:flutter/material.dart';
import 'package:gym_bro/providers/workout_provider.dart';
import 'package:gym_bro/ui/screens/dashboard/widgets/my_workouts.dart';
import 'package:gym_bro/ui/screens/dashboard/widgets/weekly_summary.dart';
import 'package:gym_bro/utils/utils.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    Future.microtask(
      () => Provider.of<WorkoutProvider>(context, listen: false).loadAll(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Utils.deleteDatabaseFile();
        },
      ),
      appBar: AppBar(title: Text("Bom dia, Preguicinha!"), centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            WeeklySummary(
              workouts: Provider.of<WorkoutProvider>(context).workouts,
            ),
            SizedBox(height: 32),
            Expanded(child: MyWorkouts()),
          ],
        ),
      ),
    );
  }
}
