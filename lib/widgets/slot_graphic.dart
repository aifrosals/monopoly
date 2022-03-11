import 'package:flutter/cupertino.dart';

class SlotGraphic {
  static BoxDecoration getBackgroundImageDecoration(String type) {
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
      case 'treasure_hunt':
        {
          return const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/tresurehunt-bg.webp')));
        }
      default:
        {
          return const BoxDecoration();
        }
    }
  }

  static String getBackgroundImage(String type) {
    switch (type) {
      case 'black_hole':
        {
          return 'assets/images/blackhole-bg.jpg';
        }
      case 'worm_hole':
        {
          return 'assets/images/wormhole.jpg';
        }
      case 'treasure_hunt':
        {
          return 'assets/images/tresurehunt-bg.webp';
        }
      default:
        {
          return 'assets/images/slot_bg.png';
        }
    }
  }

}
