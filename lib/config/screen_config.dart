import 'package:flutter/material.dart';

class ScreenConfig {
  static late MediaQueryData? _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockWidth;
  static late double blockHeight;

  static late double dpi;
  static double appBarHeight = 0.0;
  static double paddingTop = 0.0;

  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeWidth;
  static late double safeHeight;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    dpi = _mediaQueryData!.devicePixelRatio;
    appBarHeight = AppBar().preferredSize.height;
    paddingTop = _mediaQueryData != null ? _mediaQueryData!.padding.top : 0.0;
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;

    _safeAreaHorizontal = (_mediaQueryData?.padding.left ?? 0) +
        (_mediaQueryData?.padding.right ?? 0);
    _safeAreaVertical = (_mediaQueryData?.padding.top ?? 0) +
        (_mediaQueryData?.padding.bottom ?? 0);
    safeWidth = screenWidth - _safeAreaHorizontal / 100;
    safeHeight = screenHeight - _safeAreaVertical / 100;
  }
}
