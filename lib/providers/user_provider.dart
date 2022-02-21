import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/user.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  final _scrollController = ScrollController();

   User _user = User(
      presence: 'offline',
      loops: 0,
      dice: 0,
      credits: 0,
      id: '',
      serverId: '',
      challengeProgress: 0,
      shield: Shield(active: false),
      bonus: Bonus(active: false, moves: 0),
      items: Item(kick: 0, step: 0),
      currentSlot: 0);

  login(String id) async {
    try {
      Uri url = Uri.parse('${ApiConstants.domain}${ApiConstants.login}');
      var body = {'id': id};
      debugPrint('$url');
      var response = await http.post(
        url,
        body: json.encode(body),
        //TODO: Create jwt on server
        headers: {
          'Content-Type': 'application/json'
          // HttpHeaders.authorizationHeader: 'Bearer ${user.token}'
          //'${user.token}',
        },
      );
      debugPrint('user data ${response.body}');
      var resData = json.decode(response.body);
      //  user.id = id;
      //   user.currentSlot = resData['current_slot'];
      debugPrint(' credits from server ${resData['credits']}');
      _user = User.fromJson(resData);
    } catch (error, st) {
      debugPrint('UserProvider $error $st');
    } finally {
      notifyListeners();
    }
  }

  setCurrentSlot(int diceFace) {
    if (_user.currentSlot != null) {
      int slot = _user.currentSlot! + diceFace;
      if (slot > 16) {
        _user.currentSlot = slot - 17;
        _user.loops = _user.loops + 1;
      } else {
        _user.currentSlot = slot;
      }
      debugPrint('user currentSlot ${_user.currentSlot}');
      // _scrollController.animateTo(60.0 * _user.currentSlot!,
      //     duration: const Duration(milliseconds: 1500), curve: Curves.easeOut);
    }

    notifyListeners();
  }

  /// This is function for testing purposes
  /// to go back to the previous slot
  setPreviousSlot() {
    if (_user.currentSlot != null) {
      if (_user.currentSlot == 0) {
        _user.currentSlot = 16;
      } else {
        _user.currentSlot = _user.currentSlot! - 1;
      }
      debugPrint('user current slot ${_user.currentSlot}');
    }
    notifyListeners();
  }

  setCurrentSlotServer(User user) {
    if (_user.currentSlot != null) {
      _user.currentSlot = user.currentSlot;
      debugPrint('user currentSlot ${_user.currentSlot}');
      // _scrollController.animateTo(60.0 * _user.currentSlot!,
      //     duration: const Duration(milliseconds: 1500), curve: Curves.easeOut);
    }

    notifyListeners();
  }

  setScroll() {
    debugPrint('scrolled');
    _scrollController.animateTo(60.0 * _user.currentSlot!,
        duration: const Duration(milliseconds: 1500), curve: Curves.easeOut);
    debugPrint('Current position pixel ${_scrollController.position.pixels}');
  }

  incrementCredits() {
    if (_user.bonus.active) {
      _user.credits = _user.credits + 2;
    } else {
      _user.credits++;
    }
    notifyListeners();
  }

  setAnimationScroll(double size) {
    _scrollController.animateTo(size,
        duration: const Duration(milliseconds: 1500), curve: Curves.easeOut);
  }

  updateUser(User user) {
    debugPrint('update user gets called ${user.currentSlot}');
    _user = user;
    notifyListeners();
  }

  User get user => _user;

  ScrollController get scrollController => _scrollController;
}