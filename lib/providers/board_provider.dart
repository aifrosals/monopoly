import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/slot.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/models/user.dart';

class BoardProvider extends ChangeNotifier {
  List<Slot> _slots = [];

  getBoardSlots() async {
    try {
      debugPrint('called');
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
      debugPrint('BoardProvider getBoardSlots ${response.body}');
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

  updateBoardSlots(dynamic data) {
    try {
      data as List;
      _slots = data.map((e) => Slot.fromJson(e)).toList();
      debugPrint('slots data ${_slots[9]}');
    } catch (error, st) {
      debugPrint('BoardProvider updateBoardSlots $error $st');
    } finally {
      notifyListeners();
    }
  }

  //TODO: Either remove or use with delay animations
  Future<User> checkSlotEffect(User user) async {
    if (user.currentSlot != null) {
      Slot slot = _slots[user.currentSlot!];
      switch (slot.type) {
        case 'black_hole':
          {
            user = await blackHoleEffect(user);
          }
          break;
      }
    }
    return user;
  }

  Future<User> blackHoleEffect(User user) async {
    await Future.delayed(const Duration(seconds: 1));

    /// randomly push to previous slot
    Random random = Random();
    int limit = user.currentSlot! - 1;
    int randomPreviousSlot = random.nextInt(limit);
    user.currentSlot = randomPreviousSlot;
    return user;
  }

  List<Slot> get slots => _slots;
}
