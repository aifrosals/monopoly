import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  int _time = 0;
  Timer? _timer;

  TimerProvider() {
    startTimer();
  }

  startTimer() {
    _time = 90;
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
