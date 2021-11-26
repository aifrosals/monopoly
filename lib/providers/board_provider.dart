import 'package:flutter/cupertino.dart';
import 'package:monopoly/models/slot.dart';

class BoardProvider extends ChangeNotifier {
    List<Slot> slot = [
      Slot(type: 'start', name: 'Start Here'),
      Slot(type: 'land', name: 'For Sell', price:  2 + 10),
      Slot(type: 'house', name: 'House'),
      Slot(type: 'chest', name: 'Community Chest'),
      Slot(type: 'chance', name: 'Chance'),
      Slot(type: 'black_hole', name: 'Black hole'),
      Slot(type: 'land', name: 'For Sell'),
      Slot(type: 'shop', name: 'shop'),
      Slot(type: 'shop', name: 'shop'),
      Slot(type: 'condo', name: 'Condo'),
    ];
}