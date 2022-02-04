import 'package:flutter/material.dart';

class User {
  String id;
  int? currentSlot;
  int? dice;
  int credits;
  int loops;
  Bonus bonus;
  Shield shield;
  String? serverId;
  String presence;

  User(
      {required this.id,
      required this.credits,
      required this.dice,
      required this.loops,
      required this.bonus,
      this.serverId,
      required this.shield,
      required this.presence,
      this.currentSlot});

  factory User.fromJson(Map<String, dynamic> json) {
    Bonus bonus = Bonus(active: false, moves: 0);
    Shield shield = Shield(active: false);
    try {
      bonus = Bonus.fromJson(json['bonus']);
    } catch (error, st) {
      debugPrint('User bonus parsing error $error');
    }

    try {
      shield = Shield.fromJson(json['shield']);
    } catch (error, st) {
      debugPrint('user shield parsing error $error');
    }

    return User(
        id: json['id'],
        credits: json['credits'] ?? 0,
        dice: json['dice'] ?? 0,
        loops: json['loops'] ?? 0,
        presence: json['presence'] ?? 'none',
        currentSlot: json['current_slot'] ?? 0,
        serverId: json['_id'] ?? '',
        bonus: bonus,
        shield: shield);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'credits': credits,
      'loops': loops,
      'presence': presence,
      'current_slot': currentSlot,
      'dice': dice,
      'bonus': bonus.toJson()
    };
  }
}

class Bonus {
  int moves;
  bool active;

  Bonus({required this.moves, required this.active});

  factory Bonus.fromJson(Map<String, dynamic> json) {
    return Bonus(moves: json['moves'], active: json['active']);
  }

  Map<String, dynamic> toJson() {
    return {'moves': moves, 'active': active};
  }
}

class Shield {
  bool active;
  String? date;

  Shield({this.date, required this.active});

  factory Shield.fromJson(Map<String, dynamic> json) {
    return Shield(date: json['date'], active: json['active']);
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'active': active};
  }
}
