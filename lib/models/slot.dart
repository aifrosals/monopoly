import 'package:flutter/material.dart';
import 'package:monopoly/config/extensions.dart';
import 'package:monopoly/models/user.dart';

class Slot {
  String name;
  GlobalKey? endKey;

  /// type indicates the current type of the slot
  String type;
  String initialType;
  User? owner;
  int? price;
  int? updatedPrice;
  int? level;
  String? status;
  int index;
  Color color;
  Map<String, dynamic>? allStepCount;

  Slot(
      {required this.name,
      required this.type,
      required this.index,
      this.endKey,
      this.price,
      this.updatedPrice,
      this.owner,
      this.status,
      this.level,
      required this.color,
      this.allStepCount,
      required this.initialType});

  factory Slot.fromJson(Map<String, dynamic> json) {
    User? user;
    try {
      if (json['owner'] == null) {
        debugPrint('owner is null');
      } else {
        debugPrint('owner is not null ${json['owner']['id']}');
        user = User.fromJson(json['owner']);
      }
    } catch (error, st) {
      debugPrint('parsing owner error $error $st');
    }
    return Slot(
      name: json['name'],
      type: json['current_type'],
      color: json['color'].toString().toColor(),
      initialType: json['initial_type'],
      price: json['land_price'],
      owner: user,
      index: json['index'],
      level: json['level'],
      status: json['status'] ?? '',
      updatedPrice: json['updated_price'],
      allStepCount: json['all_step_count'],
      endKey: json['initial_type'] == 'end' ? GlobalKey() : null,
    );
  }

  int getRent() {
    if (updatedPrice != null) {
      int rent = (updatedPrice! * 10 / 100).ceil();
      return rent;
    } else {
      return 0;
    }
  }

  int getHalfSellingPrice() {
    return (getSellingPrice() / 2).ceil();
  }

  int getSellingPrice() {
    if (updatedPrice != null && level != null) {
      int sellingPrice = updatedPrice! * getSellingFactor(level!);
      return sellingPrice;
    } else {
      return 0;
    }
  }

  int getSellingFactor(int level) {
    switch (level) {
      case 0:
        {
          return 20;
        }
      case 1:
        {
          return 15;
        }
      case 2:
        {
          return 10;
        }
      case 3:
        {
          return 8;
        }
      case 4:
        {
          return 6;
        }
      case 5:
        {
          return 4;
        }
      default:
        {
          return 1;
        }
    }
  }
}
