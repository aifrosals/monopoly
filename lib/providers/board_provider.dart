import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/models/slot.dart';

class BoardProvider extends ChangeNotifier {
    final List<Slot> _slots = [
      Slot(type: 'start', name: 'Start Here', color: Colors.yellow[700]!),
      Slot(type: 'land', name: 'For Sell', color: Colors.orange, price:  2 + 10),
      Slot(type: 'house', name: 'House', color: Colors.teal),
      Slot(type: 'chest', name: 'Community Chest', color: Colors.blue),
      Slot(type: 'chance', name: 'Chance', color: Colors.deepPurple),
      Slot(type: 'black_hole', name: 'Black hole', color: Colors.black45),
      Slot(type: 'land', name: 'For Sell', color: Colors.pinkAccent),
      Slot(type: 'shop', name: 'shop', color: Colors.teal),
      Slot(type: 'shop', name: 'shop', color: Colors.yellow[700]!),
      Slot(type: 'condo', name: 'Condo', color: Colors.green),
      Slot(type: 'challenge', name: 'Challenge', color: Colors.orange),
      Slot(type: 'condo', name: 'Condo', color: Colors.green),
      Slot(type: 'city', name: 'City', color: Colors.pinkAccent),
      Slot(type: 'treasure_hunt', name: 'Treasure hunt', color: Colors.black54),
      Slot(type: 'wormhole', name: 'Worm Hole', color: Colors.indigo),
      Slot(type: 'reward', name: 'Worm Hole', color: Colors.blue[700]!),
      Slot(type: 'finish', name: 'The End', color: Colors.tealAccent),
    ];



    List<Slot> get slots => _slots;
}