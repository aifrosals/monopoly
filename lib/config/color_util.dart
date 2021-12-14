import 'dart:math';

import 'package:flutter/material.dart';

class ColorUtil {
  static Color randomColor() {
    return Color(Random().nextInt(0xffffffff));
  }
}
