import 'package:flutter/material.dart';
import 'package:monopoly/config/extensions.dart';

class Slot {
  String name;
  String type;
  String initialType;
  String? owner;
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
    return Slot(
        name: json['name'],
        type: json['current_type'],
        color: json['color'].toString().toColor(),
        initialType: json['initial_type'],
        price: json['land_price'],
        owner: json['owner'],
        updatedPrice: json['updated_price']);
  }
}
