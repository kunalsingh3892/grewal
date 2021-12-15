import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Clock extends StatefulWidget {


  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  int _start = 90;
  Timer timer;

  void resetTimer() {


    if (timer != null && timer.isActive) {
      timer.cancel();
    }

    timer = Timer.periodic(Duration(minutes: 1), (t) {
      if (mounted) {
        if (_start == 0) {
          setState(() {
            timer.cancel();

          });
        } else {
          setState(() {
            _start--;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    resetTimer();
  }

  @override
  void didUpdateWidget(covariant Clock oldWidget) {
    super.didUpdateWidget(oldWidget);
    resetTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) =>null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

      timer.cancel();
      WidgetsFlutterBinding.ensureInitialized()
          .addPostFrameCallback((timeStamp) {
        resetTimer();
       // widget.onTimerEnd();
      });


    return Container(
      padding: const EdgeInsets.all(2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.purple,
      ),
      child: Container(
        height: 30,
        width: 30,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,

        ),
        child:
              Center(
                child: Container(
                  child: Center(child: Text("$_start",style: TextStyle(color: Colors.white,fontSize: 16),)),
                ),
              ),



      ),
    );
  }
}