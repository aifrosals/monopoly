import 'dart:math';

import 'package:flutter/cupertino.dart';

class DiceProvider extends ChangeNotifier {
   int _dice = 0;
  int _face = 0;

  rollDice() {
    Random random = Random();
    _face = random.nextInt(6) + 1;
    // _face = 1;
    debugPrint('face of the dice: $_face');
    notifyListeners();
    return _face;
  }

  getOne() {
    _face = 1;
    notifyListeners();
    return _face;
  }

  resetFace() {
    _face = 0;
    notifyListeners();
  }

  int get face => _face;
}