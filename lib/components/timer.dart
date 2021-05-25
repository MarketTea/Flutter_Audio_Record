import 'dart:async';
import 'package:flutter/material.dart';

class TimerWatch extends StatefulWidget {
  TimerWatch({this.stopwatch});

  final Stopwatch stopwatch;

  @override
  TimerWatchState createState() => TimerWatchState(stopwatch: stopwatch);
}

class TimerWatchState extends State<TimerWatch> {
  Timer timer;
  final Stopwatch stopwatch;

  TimerWatchState({this.stopwatch}) {
    timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
  }

  void callback(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {});
    }
  }

  String timerTextFormatter(int time) {
    Duration duration = Duration(milliseconds: time);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle timerTextStyle =
        const TextStyle(fontSize: 60.0, fontFamily: "Open Sans");
    String formattedTime = timerTextFormatter(stopwatch.elapsedMilliseconds);
    return new Stack(
      children: [
        Container(
          height: 300,
          width: 300,
          alignment: Alignment.center,
          child: Text(
            formattedTime,
            style: timerTextStyle,
          ),
          decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.teal[400], width: 3.0)),
        ),
      ],
    );
  }
}
