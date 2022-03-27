import 'dart:async';

import 'package:flutter/cupertino.dart';

class UserPresenceTimerProvider extends ChangeNotifier {
  int _time = 0;

  Timer? timer;
}
