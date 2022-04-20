import 'package:flutter/material.dart';

class TimeSeriesLogin {
  final DateTime? date;
  final int? users;

  TimeSeriesLogin({required this.date, required this.users});

  factory TimeSeriesLogin.fromJson(Map<String, dynamic> json) {
    DateTime? date;
    try {
      date = DateTime.parse(json['_id']);
    } catch (error, st) {
      debugPrint('error parsing date $error $st');
    }
    return TimeSeriesLogin(date: date, users: json['usersCount']);
  }
}
