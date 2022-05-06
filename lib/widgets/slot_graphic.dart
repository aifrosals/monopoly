import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/config/values.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/pages/board/view/black_hole_view.dart';
import 'package:monopoly/pages/board/view/business_center_view.dart';
import 'package:monopoly/pages/board/view/challenge_view.dart';
import 'package:monopoly/pages/board/view/chance_view.dart';
import 'package:monopoly/pages/board/view/chest_view.dart';
import 'package:monopoly/pages/board/view/city_view.dart';
import 'package:monopoly/pages/board/view/condo_view.dart';
import 'package:monopoly/pages/board/view/end_view.dart';
import 'package:monopoly/pages/board/view/house_view.dart';
import 'package:monopoly/pages/board/view/land_view.dart';
import 'package:monopoly/pages/board/view/reward_view.dart';
import 'package:monopoly/pages/board/view/shop_view.dart';
import 'package:monopoly/pages/board/view/start_view.dart';
import 'package:monopoly/pages/board/view/theme_park_view.dart';
import 'package:monopoly/pages/board/view/treasure_hunt_view.dart';
import 'package:monopoly/pages/board/view/worm_hole_view.dart';
import 'package:monopoly/widgets/slot_information_dialog.dart';

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

  static Widget getSlotWidget(Slot slot) {
    switch (slot.type) {
      case 'start':
        {
          return StartView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'land':
        {
          return LandView(
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
            slot: slot,
          );
        }
      case 'house':
        {
          return HouseView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'chest':
        {
          return ChestView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'chance':
        {
          return ChanceView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'black_hole':
        {
          return BlackHoleView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'condo':
        {
          return CondoView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'theme_park':
        {
          return ThemeParkView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'challenge':
        {
          return ChallengeView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'shop':
        {
          return ShopView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'business_center':
        {
          return BusinessCenterView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'city':
        {
          return CityView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'treasure_hunt':
        {
          return TreasureHuntView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'worm_hole':
        {
          return WormHoleView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'reward':
        {
          return RewardView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      case 'end':
        {
          return EndView(
            slot: slot,
            onSlotClick: () {
              showDialog(
                  context: Values.navigatorKey.currentContext!,
                  builder: (context) => SlotInformationDialog(slot: slot));
            },
          );
        }
      default:
        return const SizedBox();
    }
  }
}
