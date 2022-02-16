import 'package:flutter/material.dart';

class Question {
  String statement;
  List<String>? options;
  int? answer;
  String? id;
  Map<String, dynamic>? results;

  Question(
      {this.answer,
      required this.options,
      required this.statement,
      this.id,
      this.results});

  factory Question.fromJson(Map<String, dynamic> json) {
    List<String>? _options = [];
    try {
      var data = json['options'] as List;
      _options = data.map((e) => e.toString()).toList();
    } catch (error, st) {
      debugPrint('parsing options error $error $st');
    }
    return Question(
        answer: null,
        options: _options,
        statement: json['statement'],
        id: json['_id']);
  }

  factory Question.fromJsonGet(Map<String, dynamic> json) {
    List<String>? _options = [];
    try {
      var data = json['options'] as List;
      _options = data.map((e) => e.toString()).toList();
    } catch (error, st) {
      debugPrint('parsing options error $error $st');
    }
    return Question(
        answer: json['answer'],
        options: _options,
        statement: json['statement'],
        id: json['_id'],
        results: json['user_results']);
  }

  int getCorrect() {
    int correct = 0;
    if (results != null && results!.isNotEmpty) {
      results!.forEach((key, value) {
        if (value == true) {
          correct++;
        }
      });
    }
    return correct;
  }

  int getIncorrect() {
    int incorrect = 0;
    if (results != null && results!.isNotEmpty) {
      results!.forEach((key, value) {
        if (value == true) {
          incorrect++;
        }
      });
    }
    return incorrect;
  }

  toJson() {
    return {
      'answer': answer,
      'options': options,
      'id': id,
      'statement': statement
    };
  }
}
