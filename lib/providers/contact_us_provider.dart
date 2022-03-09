import 'package:flutter/cupertino.dart';

class ContactUsProvider extends ChangeNotifier {
  String _type = 'For Contact Us';
  final List<String> _types = [
    'For Contact Us',
    'For Complain',
    'For Feedback'
  ];

  setType(String type) {
    _type = type;
    notifyListeners();
  }

  String get type => _type;

  List<String> get types => _types;
}