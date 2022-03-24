import 'package:monopoly/models/user.dart';

class Feedback {
  String email;
  String type;
  String message;
  bool seen;
  String date;
  User? user;

  Feedback(
      {required this.email,
      required this.type,
      required this.message,
      required this.seen,
      required this.date,
      this.user});

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      email: json['email'],
      type: json['type'],
      message: json['message'],
      seen: json['seen'],
      date: json['createdAt'],
      user: User.fromJson(json['user']),
    );
  }

  toMap() {
    return {
      'email': email,
      'type': type,
      'seen': seen,
      'message': message,
      'date': date,
      'user': user != null ? user!.serverId : ''
    };
  }
}
