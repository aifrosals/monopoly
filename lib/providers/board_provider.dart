import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/slot.dart';
import 'package:http/http.dart' as http;

class BoardProvider extends ChangeNotifier {
  List<Slot> _slots = [
    // Slot(type: 'start', name: 'Start Here', color: Colors.yellow[700]!),
    // Slot(type: 'land', name: 'For Sell', color: Colors.orange, price:  2 + 10),
    // Slot(type: 'house', name: 'House', color: Colors.teal),
    // Slot(type: 'chest', name: 'Community Chest', color: Colors.blue),
    // Slot(type: 'chance', name: 'Chance', color: Colors.deepPurple),
    // Slot(type: 'black_hole', name: 'Black hole', color: Colors.black45),
    // Slot(type: 'land', name: 'For Sell', color: Colors.pinkAccent),
    // Slot(type: 'shop', name: 'shop', color: Colors.teal),
    // Slot(type: 'shop', name: 'shop', color: Colors.yellow[700]!),
    // Slot(type: 'condo', name: 'Condo', color: Colors.green),
    // Slot(type: 'challenge', name: 'Challenge', color: Colors.orange),
    // Slot(type: 'condo', name: 'Condo', color: Colors.green),
    // Slot(type: 'city', name: 'City', color: Colors.pinkAccent),
    // Slot(type: 'treasure_hunt', name: 'Treasure hunt', color: Colors.black54),
    // Slot(type: 'wormhole', name: 'Worm Hole', color: Colors.indigo),
    // Slot(type: 'reward', name: 'Reward', color: Colors.blue[700]!),
    // Slot(type: 'end', name: 'The End', color: Colors.tealAccent),
  ];

  getBoardSlots() async {
    try {
      Uri url = Uri.parse('${ApiConstants.domain}${ApiConstants.slots}');
      // var body = {'id': id};
      debugPrint('$url');
      var response = await http.get(
        url,
        // body: json.encode(body),
        //TODO: Create jwt on server
        headers: {
          'Content-Type': 'application/json'
          // HttpHeaders.authorizationHeader: 'Bearer ${user.token}'
          //'${user.token}',
        },
      );
      debugPrint(response.body);
      var resData = json.decode(response.body) as List;
      _slots = resData.map((e) => Slot.fromJson(e)).toList();
      //  user.id = id;
      //   user.currentSlot = resData['current_slot'];

    } catch (error, st) {
      debugPrint('BoardProvider $error $st');
    } finally {
      notifyListeners();
    }
  }

  List<Slot> get slots => _slots;
}
