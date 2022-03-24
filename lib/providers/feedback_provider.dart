import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/models/admin.dart';
import 'package:monopoly/models/feedback.dart' as feedback;
import 'package:monopoly/models/user.dart';
import 'package:monopoly/widgets/helping_dialog.dart';

class FeedbackProvider extends ChangeNotifier {
  FeedbackProvider.admin(Admin admin) {
    getFeedbacks(admin);
  }

  FeedbackProvider();

  bool _feedbackLoading = false;

  String _errorMessage = '';

  bool _feedbackPaginationLoading = false;

  List<feedback.Feedback> _feedbacks = [];

  submitFeedback(User user, String type, String email, String message) async {
    try {
      _feedbackLoading = true;
      notifyListeners();

      Uri url =
          Uri.parse('${ApiConstants.domain}${ApiConstants.submitFeedback}');
      var body = {
        'id': user.serverId,
        'type': type,
        'email': email,
        'message': message,
      };
      debugPrint('$url');
      var response = await http.post(
        url,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': user.token ?? ''
        },
      );
      if (response.statusCode == 200) {
        HelpingDialog.showServerResponseDialog('Submitted Successfully');
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403 ||
          response.statusCode == 405) {
        HelpingDialog.showServerResponseDialog(response.body);
      } else {
        HelpingDialog.showServerResponseDialog('Server Error');
      }
    } catch (error, st) {
      debugPrint('getTreasureHuntReward error $error $st');
      HelpingDialog.showServerResponseDialog('Unknown error');
    } finally {
      _feedbackLoading = false;
      notifyListeners();
    }
  }

  getFeedbacks(Admin admin) async {
    try {
      debugPrint('getFeedback called');
      _feedbackLoading = true;
      Uri url = Uri.parse('${ApiConstants.domain}${ApiConstants.getFeedback}');
      var response = await http.get(
        url,
        //TODO: Create jwt on server
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': admin.token
        },
      );
      debugPrint('FeedbackProvider getFeedback  response ${response.body}');
      if (response.statusCode == 200) {
        debugPrint('FeedbackProvider getFeedback response ${response.body}');
        var resData = json.decode(response.body) as List;
        _feedbacks = resData.map((e) => feedback.Feedback.fromJson(e)).toList();
        _errorMessage = '';
      } else {
        _errorMessage = response.body;
      }
    } catch (error, st) {
      debugPrint('FeedbackProvider getFeedback $error $st');
    } finally {
      _feedbackLoading = false;
      notifyListeners();
    }
  }

  getPaginatedFeedbacks(Admin admin) async {
    if (_feedbacks.isNotEmpty) {
      try {
        _feedbackPaginationLoading = true;
        Uri url = Uri.parse(
            '${ApiConstants.domain}${ApiConstants.getPaginatedFeedback}');
        var body = {'lastDate': _feedbacks.last.date};
        var response = await http.post(
          url,
          body: json.encode(body),
          headers: {
            'Content-Type': 'application/json',
            'x-access-token': admin.token
          },
        );
        debugPrint('FeedbackProvider getFeedbacks response ${response.body}');
        if (response.statusCode == 200) {
          debugPrint('FeedbackProvider getFeedbacks response ${response.body}');
          var resData = json.decode(response.body) as List;
          _feedbacks.addAll(
              resData.map((e) => feedback.Feedback.fromJson(e)).toList());
          _errorMessage = '';
        } else {
          _errorMessage = response.body;
        }
      } catch (error, st) {
        debugPrint('TransactionProvider getTransaction $error $st');
        _errorMessage = "Unknown error";
      } finally {
        _feedbackPaginationLoading = false;
        notifyListeners();
      }
    }
  }

  bool get feedbackLoading => _feedbackLoading;

  bool get feedbackPaginationLoading => _feedbackPaginationLoading;

  List<feedback.Feedback> get feedbacks => _feedbacks;
}
