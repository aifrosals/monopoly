import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/web/widgets/web_dialog.dart';

class AdminUserProvider extends ChangeNotifier {
  bool _userLoading = false;

  String _query = '';

  List<User> _users = [];

  AdminUserProvider() {
    getAllUsers();
  }

  setState() {
    notifyListeners();
  }

  getAllUsers() async {
    try {
      await Future.delayed(Duration.zero);
      _userLoading = true;
      Uri url = Uri.parse('${ApiConstants.domain}${ApiConstants.getAllUsers}');
      debugPrint('$url');
      var response = await http.get(
        url,
        //TODO: Create jwt on server
        headers: {
          'Content-Type': 'application/json'
          // HttpHeaders.authorizationHeader: 'Bearer ${user.token}'
          //'${user.token}',
        },
      );
      debugPrint('getAllUsers response ${response.body}');
      if (response.statusCode == 200) {
        var resData = json.decode(response.body) as List;
        _users = resData.map((e) => User.fromJson(e)).toList();
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403 ||
          response.statusCode == 405) {
        WebDialog.showServerResponseDialog(response.body);
      } else {
        WebDialog.showServerResponseDialog('Unknown Server Error');
      }
    } catch (error, st) {
      debugPrint('getAllUsers $error $st');
    } finally {
      _userLoading = false;
      notifyListeners();
    }
  }

  inputQuery(String query) {
    _query = query;
    searchUser(_query);
  }

  searchUser(String query) async {
    if (query.isEmpty || query == '') {
      await getAllUsers();
    } else {
      _users = _users
          .where((user) =>
              user.id.toLowerCase().contains(query.toLowerCase()) ||
              user.serverId.contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  setPremiumStatus(User user, bool premium) async {
    if (premium) {
      await activatePremium(user);
    } else {
      await deactivatePremium(user);
    }
  }

  activatePremium(User user) async {
    try {
      await Future.delayed(Duration.zero);
      _userLoading = true;
      Uri url =
          Uri.parse('${ApiConstants.domain}${ApiConstants.activatePremium}');
      debugPrint('$url');
      var body = {'id': user.serverId};
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
      debugPrint('getAllUsers response ${response.body}');
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        User user = User.fromJson(resData);
        WebDialog.showServerResponseDialog('Premium activated');
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403 ||
          response.statusCode == 405) {
        WebDialog.showServerResponseDialog(response.body);
      } else {
        WebDialog.showServerResponseDialog('Unknown Server Error');
      }
    } catch (error, st) {
      debugPrint('activatePremium $error $st');
    } finally {
      _userLoading = false;
      notifyListeners();
      getAllUsers();
    }
  }

  deactivatePremium(User user) async {
    try {
      await Future.delayed(Duration.zero);
      _userLoading = true;
      Uri url =
          Uri.parse('${ApiConstants.domain}${ApiConstants.deactivatePremium}');
      debugPrint('$url');
      var body = {'id': user.serverId};
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
      debugPrint('getAllUsers response ${response.body}');
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        User user = User.fromJson(resData);
        WebDialog.showServerResponseDialog('Premium deactivated');
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403 ||
          response.statusCode == 405) {
        WebDialog.showServerResponseDialog(response.body);
      } else {
        WebDialog.showServerResponseDialog('Unknown Server Error');
      }
    } catch (error, st) {
      debugPrint('UserProvider $error $st');
    } finally {
      _userLoading = false;
      notifyListeners();
      getAllUsers();
    }
  }

  addDices(User user, int dices) async {
    try {
      await Future.delayed(Duration.zero);
      _userLoading = true;
      Uri url = Uri.parse('${ApiConstants.domain}${ApiConstants.addDice}');
      debugPrint('$url');
      var body = {'id': user.serverId, 'dices': dices};
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
      debugPrint('getAllUsers response ${response.body}');
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        User user = User.fromJson(resData);
        WebDialog.showServerResponseDialog('Dices Added');
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403 ||
          response.statusCode == 405) {
        WebDialog.showServerResponseDialog(response.body);
      } else {
        WebDialog.showServerResponseDialog('Unknown Server Error');
      }
    } catch (error, st) {
      debugPrint('UserProvider $error $st');
    } finally {
      _userLoading = false;
      notifyListeners();
      getAllUsers();
    }
  }

  List<User> get users => _users;

  bool get userLoading => _userLoading;
}
