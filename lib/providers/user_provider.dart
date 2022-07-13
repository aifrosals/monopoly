import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/user.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  final _scrollController = ScrollController();

  String _sessionError = '';

  int _slotSize = 0;

  User _user = User(
      token: '',
      email: '',
      presence: 'offline',
      loops: 0,
      dice: 0,
      credits: 0,
      diceUpdatedAt: '',
      premium: false,
      id: '',
      serverId: '',
      cash: 0,
      guest: true,
      challengeProgress: 0,
      shield: Shield(active: false),
      bonus: Bonus(active: false, moves: 0),
      items: Item(kick: 0, step: 0),
      currentSlot: 0);

  Future<Map<String, dynamic>> registerUserWithEmail(String email, String id, String password, String confirmPassword) async {
    try {
      Uri url = Uri.parse(
          '${ApiConstants.domain}${ApiConstants.registerUserWithEmail}');
      var body = {
        'email': email,
        'id': id,
        'password': password,
        'confirmPassword': confirmPassword
      };
      debugPrint('$url');
      var response = await http.post(
        url,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        debugPrint('user data ${response.body}');
        var resData = json.decode(response.body);
        debugPrint(' credits from server ${resData['credits']}');
        _user = User.fromJson(resData);
        await saveSession(_user);

        return {
          'status': true,
        };
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403 ||
          response.statusCode == 405) {
        return {'status': false, 'message': response.body};
      } else {
        return {
          'status': false,
          'message': 'Unknown server error ${response.statusCode}'
        };
      }
    } catch (error, st) {
      debugPrint('UserProvider $error $st');
      return {'status': false, 'message': 'Unknown error'};
    } finally {
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> registerGuestWithEmail(
      String email, String id, String password, String confirmPassword) async {
    try {
      Uri url = Uri.parse(
          '${ApiConstants.domain}${ApiConstants.registerGuestWithEmail}');
      var body = {
        'email': email,
        'id': id,
        'password': password,
        'confirmPassword': confirmPassword,
        'serverId': user.serverId,
      };
      debugPrint('$url');
      var response = await http.post(
        url,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        debugPrint('user data ${response.body}');
        var resData = json.decode(response.body);
        debugPrint(' credits from server ${resData['credits']}');
        _user = User.fromJson(resData);
        await saveSession(_user);
        return {
          'status': true,
        };
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403 ||
          response.statusCode == 405) {
        return {'status': false, 'message': response.body};
      } else {
        return {
          'status': false,
          'message': 'Unknown server error ${response.statusCode}'
        };
      }
    } catch (error, st) {
      debugPrint('UserProvider $error $st');
      return {'status': false, 'message': 'Unknown error'};
    } finally {
      debugPrint('guest with email ${_user.guest} ${_user.serverId}');
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> registerGuest() async {
    try {
      Uri url =
          Uri.parse('${ApiConstants.domain}${ApiConstants.registerGuest}');
      debugPrint('$url');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        debugPrint('user data ${response.body}');
        var resData = json.decode(response.body);
        debugPrint(' credits from server ${resData['credits']}');
        _user = User.fromJson(resData);
        await saveSession(_user);

        return {
          'status': true,
        };
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403 ||
          response.statusCode == 405) {
        return {'status': false, 'message': response.body};
      } else {
        return {
          'status': false,
          'message': 'Unknown server error ${response.statusCode}'
        };
      }
    } catch (error, st) {
      debugPrint('UserProvider $error $st');
      return {'status': false, 'message': 'Unknown error'};
    } finally {
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> loginWithEmail(
      String email, String password) async {
    {
      try {
        Uri url =
            Uri.parse('${ApiConstants.domain}${ApiConstants.loginWithEmail}');
        var body = {
          'email': email,
          'password': password,
        };
        debugPrint('$url');
        var response = await http.post(
          url,
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          debugPrint('user data ${response.body}');
          var resData = json.decode(response.body);
          debugPrint(' credits from server ${resData['credits']}');
          _user = User.fromJson(resData);
          await saveSession(_user);
          return {
            'status': true,
          };
        } else if (response.statusCode == 400 ||
            response.statusCode == 401 ||
            response.statusCode == 402 ||
            response.statusCode == 403 ||
            response.statusCode == 405) {
          return {'status': false, 'message': response.body};
        } else {
          return {
            'status': false,
            'message': 'Unknown server error ${response.statusCode}'
          };
        }
      } catch (error, st) {
        debugPrint('UserProvider $error $st');
        return {'status': false, 'message': 'Unknown error'};
      } finally {
        notifyListeners();
      }
    }
  }

  Future<Map<String, dynamic>> loginWithToken(String? token) async {
    {
      try {
        Uri url =
            Uri.parse('${ApiConstants.domain}${ApiConstants.loginWithToken}');
        var body = {
          'token': token,
        };
        debugPrint('$url');
        var response = await http.post(
          url,
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          debugPrint('user data ${response.body}');
          var resData = json.decode(response.body);
          debugPrint(' credits from server ${resData['credits']}');
          _user = User.fromJson(resData);
          await saveSession(_user);
          _sessionError = '';
          return {
            'status': true,
          };
        } else if (response.statusCode == 400 ||
            response.statusCode == 401 ||
            response.statusCode == 402 ||
            response.statusCode == 403 ||
            response.statusCode == 405) {
          _sessionError = response.body;
          return {'status': false, 'message': response.body};
        } else {
          _sessionError = 'Unknown server error';
          return {
            'status': false,
            'message': 'Unknown server error ${response.statusCode}'
          };
        }
      } catch (error, st) {
        debugPrint('UserProvider $error $st');
        _sessionError = 'Unknown error';
        return {'status': false, 'message': 'Unknown error'};
      } finally {
        notifyListeners();
      }
    }
  }

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
      _user.token = 'user3';
      debugPrint('user token ${_user.token}');
    } catch (error, st) {
      debugPrint('UserProvider $error $st');
    } finally {
      notifyListeners();
    }
  }

  saveSession(User user) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: user.token);
  }

  Future<String?> loadSession() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    return token;
  }

  deleteSession() {
    const storage = FlutterSecureStorage();
    _user = User(
        email: '',
        token: '',
        presence: 'offline',
        loops: 0,
        dice: 0,
        credits: 0,
        diceUpdatedAt: '',
        premium: false,
        id: '',
        serverId: '',
        cash: 0,
        guest: true,
        challengeProgress: 0,
        shield: Shield(active: false),
        bonus: Bonus(active: false, moves: 0),
        items: Item(kick: 0, step: 0),
        currentSlot: 0);
    storage.deleteAll();
  }

  setCurrentSlot(int diceFace) {
    if (_user.currentSlot != null) {
      int slot = _user.currentSlot! + diceFace;
      if (slot > _slotSize - 1) {
        _user.currentSlot = slot - _slotSize;
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

  setSlotSize(int slotSize) {
    _slotSize = slotSize;
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

  String? get sessionError => _sessionError;

  ScrollController get scrollController => _scrollController;
}
