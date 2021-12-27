import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/slot.dart';
import 'package:http/http.dart' as http;

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
    } catch (error, st) {
      debugPrint('BoardProvider updateBoardSlots $error $st');
    } finally {
      notifyListeners();
    }
  }

  List<Slot> get slots => _slots;
}
