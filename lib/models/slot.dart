import 'package:flutter/material.dart';
import 'package:monopoly/config/extensions.dart';
import 'package:monopoly/models/user.dart';

class Slot {
  String name;

  /// type indicates the current type of the slot
  String type;
  String initialType;
  User? owner;
  int? price;
  int? updatedPrice;
  int? level;
  String? status;
  Color color;
  Map<String, dynamic>? allStepCount;

  Slot(
      {required this.name,
      required this.type,
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
        level: json['level'],
        status: json['status'] ?? '',
        updatedPrice: json['updated_price'],
        allStepCount: json['all_step_count']);
  }
}
