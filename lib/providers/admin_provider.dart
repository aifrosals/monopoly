import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:http/http.dart' as http;

class AdminProvider extends ChangeNotifier {
  Future<bool> login(String email, String password) async {
    try {
      Uri uri = Uri.parse('${ApiConstants.domain}${ApiConstants.adminLogin}');
      Map body = {
        'email': email,
        'password': password,
      };
      var response = await http.post(
        uri,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json'
          // HttpHeaders.authorizationHeader: 'Bearer ${user.token}'
          //'${user.token}',
        },
      );
      debugPrint('result received ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error, st) {
      debugPrint('adminProvider login error $error $st');
      return false;
    }
  }
}
