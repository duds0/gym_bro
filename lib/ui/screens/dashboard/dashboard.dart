import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_bro/providers/workout_provider.dart';
import 'package:gym_bro/ui/screens/dashboard/widgets/my_workouts.dart';
import 'package:gym_bro/ui/screens/dashboard/widgets/weekly_summary.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _ehPreguicinha = false; //kkkk
  late Timer _timer;

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Bom dia";
    } else if (hour >= 12 && hour < 18) {
      return "Boa tarde";
    } else if (hour >= 18 && hour < 24) {
      return "Boa noite";
    } else {
      return "Boa madrugada";
    }
  }

  @override
  void initState() {
    Future.microtask(
      () => Provider.of<WorkoutProvider>(context, listen: false).loadAll(),
    );

    _timer = Timer.periodic(Duration(seconds: 15), (_) {
      setState(() {
        _ehPreguicinha = !_ehPreguicinha;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("${_greeting()}, "),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                final isEntering = child.key == ValueKey(_ehPreguicinha);

                final offsetAnimation = Tween<Offset>(
                  begin: isEntering ? const Offset(0, -1) : const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation);

                return ClipRect(
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  ),
                );
              },
              child: Text(
                _ehPreguicinha ? "Preguicinha!" : "Campeã(o)!",
                key: ValueKey(_ehPreguicinha),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
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
