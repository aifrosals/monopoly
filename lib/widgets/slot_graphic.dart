import 'package:flutter/cupertino.dart';

class SlotGraphic {
  static BoxDecoration getBackgroundImage(String type) {
    switch (type) {
      case 'black_hole':
        {
          return const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/blackhole-bg.jpg')));
        }
      case 'worm_hole':
        {
          return const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/wormhole.jpg')));
        }
      default:
        {
          return const BoxDecoration();
        }
    }
  }
}
