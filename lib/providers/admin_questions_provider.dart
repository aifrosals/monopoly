import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/admin.dart';
import 'package:monopoly/models/question.dart';
import 'package:monopoly/web/widgets/web_dialog.dart';
import 'package:http/http.dart' as http;

class AdminQuestionProvider extends ChangeNotifier {
  bool _addQuestionLoading = false;
  bool _questionLoading = false;
  List<Question> _questions = [];

  Future<bool> addQuestion(Admin admin, Question question) async {
    try {
      _addQuestionLoading = true;
      notifyListeners();
      Uri uri = Uri.parse('${ApiConstants.domain}${ApiConstants.addQuestion}');
      Map body = question.toJson();
      var response = await http.post(
        uri,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': admin.token
          // HttpHeaders.authorizationHeader: 'Bearer ${user.token}'
          //'${user.token}',
        },
      );
      debugPrint(
          'add question response ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error, st) {
      debugPrint('adminQuestionProvider addQuestion error $error $st');
      return false;
    } finally {
      _addQuestionLoading = false;
      notifyListeners();
      getQuestions(admin);
    }
  }

  Future<void> getQuestions(Admin admin) async {
    try {
      _questionLoading = true;
      await Future.delayed(const Duration(milliseconds: 1));
      notifyListeners();

      Uri uri = Uri.parse('${ApiConstants.domain}${ApiConstants.getQuestions}');
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': admin.token
        },
      );
      debugPrint(
          'getQuestions response ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        _questions = data.map((e) => Question.fromJsonGet(e)).toList();
      } else {}
    } catch (error, st) {
      debugPrint('adminQuestionProvider getQuestions error $error $st');
    } finally {
      _questionLoading = false;
      notifyListeners();
    }
  }

  updateQuestion(Admin admin, Question question) async {
    try {
      _addQuestionLoading = true;
      notifyListeners();
      Uri uri =
          Uri.parse('${ApiConstants.domain}${ApiConstants.updateQuestion}');
      Map body = question.toJson();
      var response = await http.put(
        uri,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': admin.token
        },
      );
      debugPrint(
          'update question response ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        WebDialog.showServerResponseDialog(response.body);
        return false;
      }
    } catch (error, st) {
      debugPrint('adminQuestionProvider update error $error $st');
      WebDialog.showServerResponseDialog('Unknown error code: uq100');
      return false;
    } finally {
      _addQuestionLoading = false;
      notifyListeners();
      getQuestions(admin);
    }
  }

  deleteQuestion(Admin admin, Question question) async {
    try {
      _addQuestionLoading = true;
      notifyListeners();
      Uri uri =
          Uri.parse('${ApiConstants.domain}${ApiConstants.deleteQuestion}');
      Map body = question.toJson();
      var response = await http.delete(
        uri,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': admin.token
        },
      );
      debugPrint(
          'update question response ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        WebDialog.showServerResponseDialog(response.body);
        return false;
      }
    } catch (error, st) {
      debugPrint('adminQuestionProvider update error $error $st');
      WebDialog.showServerResponseDialog('Unknown error code: uq100');
      return false;
    } finally {
      _addQuestionLoading = false;
      notifyListeners();
      getQuestions(admin);
    }
  }

  bool get addQuestionLoading => _addQuestionLoading;

  bool get questionLoading => _questionLoading;

  List<Question> get questions => _questions;
}
