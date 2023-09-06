import 'dart:async';
import 'package:flutter/material.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';

class ProgressTimer extends StatefulWidget {
  final Function() timeOut;

  ProgressTimer(this.timeOut);

  @override
  State<StatefulWidget> createState() => ProgressTimerState();
}

class ProgressTimerState extends State<ProgressTimer> {
  int time = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        time += 50;
        if (time == 5000) {
          timer.cancel();
          widget.timeOut();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: (time * 100 / 5000) / 100,
      semanticsValue: 'df',
      backgroundColor: ColorNode.itemBg,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    );
  }
}
