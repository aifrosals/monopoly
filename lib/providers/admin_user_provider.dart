import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/web/widgets/web_dialog.dart';

class AdminUserProvider extends ChangeNotifier {
  bool _userLoading = false;

  List<User> _users = [];

  AdminUserProvider() {
    getAllUsers();
  }

  getAllUsers() async {
    try {
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
      debugPrint('UserProvider $error $st');
    } finally {
      _userLoading = false;
      notifyListeners();
    }
  }

  List<User> get users => _users;

  bool get userLoading => _userLoading;
}
