import 'package:flutter/material.dart';
import 'package:monopoly/config/extensions.dart';
import 'package:monopoly/models/user.dart';

class Slot {
  String name;
  String type;
  String initialType;
  User? owner;
  int? price;
  int? updatedPrice;
  Color color;

  Slot(
      {required this.name,
      required this.type,
      this.price,
      this.updatedPrice,
      this.owner,
      required this.color,
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
        updatedPrice: json['updated_price']);
  }
}
