import 'package:flutter/material.dart';

class Slot {

  String name;
  String type;
  int? price;
  Color color;


  Slot({required this.name, required this.type, this.price, required this.color,});
}