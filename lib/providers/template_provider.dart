import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/template.dart';

import '../models/slot.dart';

class TemplateProvider extends ChangeNotifier {
  List<Template> _templates = [];

  getTemplates() async {
    try {
      //
      // await Future.delayed(const Duration(milliseconds: 1));
      // notifyListeners();

      Uri uri =
          Uri.parse('${ApiConstants.domain}${ApiConstants.getActiveTemplates}');
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // 'x-access-token': admin.token
        },
      );
      debugPrint(
          'getTemplates response ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        _templates = data.map((e) => Template.fromJson(e)).toList();
      } else {}
    } catch (error, st) {
      debugPrint('getTemplates error $error $st');
    } finally {
      notifyListeners();
    }
  }

  bool checkLevel(int level) {
    return _templates.any((element) => element.level == level);
  }

  Template getTemplateByLevel(int level) {
    return _templates.firstWhere((element) => element.level == level);
  }

  String getUpgradeName(int level) {

    if(_templates.isNotEmpty && checkLevel(level + 1)) {
      return _templates[level + 1].name;
    }
    else {
      switch (level) {
        case 0: {
          return 'House';
        }
        case 1: {
          return 'Shop';
        }
        case 2: {
          return 'Condo';
        }
        case 3: {
          return 'Business Center';
        }
        case 4: {
          return 'City';
        }
        default: {
          return 'none';
        }
      }
    }
  }

  List<Template> get templates => _templates;
}
