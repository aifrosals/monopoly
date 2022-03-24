import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  int _time = 0;

  Timer? _timer;

  TimerProvider(int time) {
    startTimer(time);
  }

  startTimer(int time) {
    _time = time;
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_time == 0) {
        _timer?.cancel();
      } else {
        _time--;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get time => _time;
}
