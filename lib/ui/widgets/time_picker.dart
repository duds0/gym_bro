import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_bro/providers/timer_picker_controller.dart';
import 'package:gym_bro/utils/utils.dart';

class TimePicker extends StatefulWidget {
  final double width;
  final double timerPickerHeight;
  final TimerPickerController timerPickerController;

  const TimePicker({
    super.key,
    required this.width,
    required this.timerPickerHeight,
    required this.timerPickerController,
  });

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  Duration _tempTimerPicked = Duration.zero;

  void _showTimerPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 32),
          height: widget.timerPickerHeight,
          color: Colors.grey.shade900,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer_sharp),
                  SizedBox(width: 8),
                  Text(
                    "Descanso",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              SizedBox(height: 24),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.ms,
                  initialTimerDuration:
                      widget.timerPickerController.timerPicked,
                  onTimerDurationChanged: (Duration newDuration) {
                    _tempTimerPicked = newDuration;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton(
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        color: CupertinoColors.systemRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: Text(
                      "Confirmar",
                      style: TextStyle(
                        color: CupertinoColors.systemBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      widget.timerPickerController.setTimerPicked(
                        _tempTimerPicked,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showTimerPicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer_sharp),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                Utils.formatDuration(widget.timerPickerController.timerPicked),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
