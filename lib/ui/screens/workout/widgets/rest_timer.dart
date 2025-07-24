import 'package:flutter/material.dart';

class RestTimer extends StatefulWidget {
  final double restMinutes;

  const RestTimer({super.key, required this.restMinutes});

  @override
  State<RestTimer> createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> {
  late int _timeLeft;

  @override
  void initState() {
    super.initState();
    _timeLeft = (widget.restMinutes * 60).round();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      if (_timeLeft > 0) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          setState(() => _timeLeft--);
        }
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double percent = _timeLeft / (widget.restMinutes * 60);

    return Dialog(
      backgroundColor: Colors.black45,
      insetPadding: const EdgeInsets.all(0),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: percent, end: percent),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) {
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 170,
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey.shade800,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),

                      Text(
                        '${(_timeLeft ~/ 60).toString().padLeft(2, '0')}:${(_timeLeft % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Concluir",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
