import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/admin.dart';
import 'package:monopoly/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/web/widgets/web_dialog.dart';

class AdminUserProvider extends ChangeNotifier {
  bool _userLoading = false;

  String _query = '';

  List<User> _users = [];

  AdminUserProvider(Admin admin) {
    getAllUsers(admin);
  }

  setState() {
    notifyListeners();
  }

  getAllUsers(Admin admin) async {
    try {
      await Future.delayed(Duration.zero);
      _userLoading = true;
      Uri url = Uri.parse('${ApiConstants.domain}${ApiConstants.getAllUsers}');
      debugPrint('$url');
      var response = await http.get(
        url,
        //TODO: Create jwt on server
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': admin.token
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

  inputQuery(Admin admin, String query) {
    _query = query;
    searchUser(admin, _query);
  }

  searchUser(Admin admin, String query) async {
    if (query.isEmpty || query == '') {
      await getAllUsers(admin);
    } else {
      _users = _users
          .where((user) =>
              user.id.toLowerCase().contains(query.toLowerCase()) ||
              user.serverId.contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  setPremiumStatus(Admin admin, User user, bool premium) async {
    if (premium) {
      await activatePremium(admin, user);
    } else {
      await deactivatePremium(admin, user);
    }
  }

  activatePremium(Admin admin, User user) async {
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
          'Content-Type': 'application/json',
          'x-access-token': admin.token
        },
      );
      debugPrint('getAllUsers response ${response.body}');
      if (response.statusCode == 200) {
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
      getAllUsers(admin);
    }
  }

  deactivatePremium(Admin admin, User user) async {
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
          'Content-Type': 'application/json',
          'x-access-token': admin.token
        },
      );
      debugPrint('getAllUsers response ${response.body}');
      if (response.statusCode == 200) {
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
      getAllUsers(admin);
    }
  }

  addDices(Admin admin, User user, int dices) async {
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
          'Content-Type': 'application/json',
          'x-access-token': admin.token
        },
      );
      debugPrint('getAllUsers response ${response.body}');
      if (response.statusCode == 200) {
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
      getAllUsers(admin);
    }
  }

  List<User> get users => _users;

  bool get userLoading => _userLoading;
}
