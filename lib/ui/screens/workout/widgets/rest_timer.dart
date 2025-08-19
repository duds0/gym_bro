import 'dart:async';
import 'package:flutter/material.dart';

class RestTimer extends StatefulWidget {
  /// Agora recebemos o tempo de descanso em MILISSEGUNDOS
  final int restTimeMs;

  const RestTimer({super.key, required this.restTimeMs});

  @override
  State<RestTimer> createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> with WidgetsBindingObserver {
  late DateTime _endTime;
  late Duration _totalDuration;
  late Duration _timeLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Converte o valor inteiro vindo do banco em Duration
    _totalDuration = Duration(seconds: widget.restTimeMs);
    _endTime = DateTime.now().add(_totalDuration);
    _timeLeft = _totalDuration;

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final diff = _endTime.difference(now);

    setState(() {
      _timeLeft = diff.isNegative ? Duration.zero : diff;
    });

    if (_timeLeft == Duration.zero) {
      _timer?.cancel();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateTime();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double percent = _timeLeft.inSeconds / _totalDuration.inSeconds;

    return Dialog(
      backgroundColor: Colors.black45,
      insetPadding: const EdgeInsets.all(0),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: percent, end: percent),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
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
                      '${_timeLeft.inMinutes.toString().padLeft(2, '0')}:${(_timeLeft.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
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
            );
          },
        ),
      ),
    );
  }
}
