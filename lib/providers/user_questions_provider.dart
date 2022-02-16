import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/config/values.dart';
import 'package:monopoly/models/question.dart';
import 'package:monopoly/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserQuestionsProvider extends ChangeNotifier {
  bool _showQ = false;
  bool _questionLoading = false;
  bool _showR = false;
  String _error = '';
  String _resultMessage = '';
  Question? _question;

  getChallengeQuestion(User user) async {
    try {
      _questionLoading = true;
      notifyListeners();

      Uri uri = Uri.parse(
          '${ApiConstants.domain}${ApiConstants.getChallengeQuestion}');
      var body = {'user': user.toJson()};
      var response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      debugPrint(
          'getQuestions response ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        _question = Question.fromJson(data.first);
        _error = '';
      } else {
        _error = response.body;
      }
    } catch (error, st) {
      _error = 'Unknown error code: uq102';
      debugPrint('user getQuestion error $error $st');
    } finally {
      _questionLoading = false;
      notifyListeners();
    }
  }

  showQuestion(User user) async {
    _showQ = true;
    notifyListeners();
    getChallengeQuestion(user);
  }

  submitQuestion(User user) async {
    try {
      _questionLoading = true;
      notifyListeners();

      Uri uri = Uri.parse('${ApiConstants.domain}${ApiConstants.submitAnswer}');
      var body = {'user': user.toJson(), 'question': _question?.toJson()};
      var response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        var data = json.decode(response.body);
        _resultMessage = data['message'];
        User rUser = User.fromJson(data['user']);
        Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
                listen: false)
            .updateUser(rUser);
      } else {
        _resultMessage = response.body;
      }
    } catch (error, st) {
      _resultMessage = 'Unknown error code: uq102';
      debugPrint('user getQuestion error $error $st');
    } finally {
      _questionLoading = false;
      notifyListeners();
    }
  }

  showResults() async {
    _showR = true;
  }

  bool get questionLoading => _questionLoading;

  bool get showQ => _showQ;

  bool get showR => _showR;

  String get error => _error;

  String get resultMessage => _resultMessage;

  Question? get question => _question;
}
