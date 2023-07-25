import 'dart:async';
import 'package:flutter/material.dart';

class StopWatchTimerPage extends StatefulWidget {
  final Function(int) timerListenerFunc;
  StopWatchTimerPage({Key? key, required this.timerListenerFunc})
      : super(key: key);
  @override
  StopWatchTimerPageState createState() => StopWatchTimerPageState();
}

class StopWatchTimerPageState extends State<StopWatchTimerPage> {
  static const countdownDuration = Duration(minutes: 10);
  Duration duration = Duration();
  Timer? timer;

  bool countDown = false;

  @override
  void initState() {
    super.initState();
    reset();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      widget.timerListenerFunc((seconds / 10).round());
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTime(),
            // SizedBox(
            //   height: 80,
            // ),
            // buildButtons()
          ],
        ),
      );
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  Widget buildTime() {
    final hours = twoDigits((duration.inMinutes / 60).round().remainder(60));
    final minutes = twoDigits((duration.inSeconds / 60).round().remainder(60));
    // int sec = duration.(duration.inSeconds/10).round()/
    final seconds = twoDigits(duration.inSeconds.round().remainder(60));
    String timeString = '${hours}:${minutes}:${seconds}';

    return Row(
      children: [
        Image.asset(
          "assets/images/timer.png",
          width: 24,
          height: 24,
        ),
        SizedBox(width: 10),
        Text('$timeString',
            style: TextStyle(
                fontFamily: "Poppins",
                color: Color(0xff353535),
                fontWeight: FontWeight.w300,
                fontSize: 13)),
      ],
    );
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: hours, header: 'MINUTES'),
      SizedBox(
        width: 8,
      ),
      buildTimeCard(time: minutes, header: 'SECONDS'),
      SizedBox(
        width: 8,
      ),
      buildTimeCard(time: seconds, header: 'SEC/10'),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15),
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          // Text(header, style: TextStyle(color: Colors.black45)),
        ],
      );

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isRunning || isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: Text('stop'),
                  onPressed: () {
                    if (isRunning) {
                      stopTimer(resets: false);
                    }
                  }),
              SizedBox(
                width: 12,
              ),
              ElevatedButton(child: Text("CANCEL"), onPressed: stopTimer),
            ],
          )
        : ElevatedButton(
            child: Text("Start Timer!"),
            //color: Colors.black,
            // backgroundColor: Colors.white,
            onPressed: () {
              startTimer();
            });
  }
}
