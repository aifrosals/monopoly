import 'package:flutter/material.dart';

class User {
  String id;
  int? currentSlot;
  int? dice;
  int credits;
  int loops;
  Bonus bonus;
  Shield shield;
  String serverId;
  String presence;
  int cash;
  int challengeProgress;
  bool premium;
  Item items;
  String diceUpdatedAt;
  String? token;
  bool guest;

  User(
      {required this.id,
      required this.credits,
      required this.dice,
      required this.loops,
      required this.bonus,
      required this.premium,
      required this.diceUpdatedAt,
      required this.challengeProgress,
      required this.serverId,
      required this.shield,
      required this.presence,
      required this.cash,
      required this.items,
      this.token,
      required this.guest,
      this.currentSlot});

  factory User.fromJson(Map<String, dynamic> json) {
    Bonus bonus = Bonus(active: false, moves: 0);
    Shield shield = Shield(active: false);
    Item items = Item(kick: 0, step: 0);

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

    try {
      items = Item.fromJson(json['items']);
    } catch (error, st) {
      debugPrint('user items parsing error $error');
    }

    return User(
        id: json['id'],
        credits: json['credits'] ?? 0,
        dice: json['dice'] ?? 0,
        loops: json['loops'] ?? 0,
        presence: json['presence'] ?? 'none',
        currentSlot: json['current_slot'] ?? 0,
        challengeProgress: json['challenge_progress'] ?? 0,
        serverId: json['_id'],
        diceUpdatedAt: json['dice_updated_at'] ?? '',
        premium: json['premium'] ?? false,
        token: json['token'],
        cash: json['cash'] ?? 0,
        guest: json['guest'] ?? true,
        bonus: bonus,
        items: items,
        shield: shield);
  }

  int getItemCount() {
    return items.step + items.kick;
  }

  String getDiceString() {
    if (dice != null) {
      return '$dice/${premium ? '15' : '10'}';
      // if (dice! <= 2) {
      //   return '0/${premium ? '20' : '15'} + $dice';
      // } else {
      //   return '${dice! - 2}/${premium ? '20' : '15'} + 2';
      // }
    } else {
      return '0/${premium ? '15' : '10'}';
    }
  }

  int getDiceTime() {
    try {
      DateTime updatedAt = DateTime.parse(diceUpdatedAt).toLocal();
      DateTime nextDate = DateTime(updatedAt.year, updatedAt.month,
          updatedAt.day, updatedAt.hour, updatedAt.minute, updatedAt.second);
      DateTime now = DateTime.now();
      if (now.isAfter(nextDate)) {
        return 0;
      }
      debugPrint('dice date $updatedAt');
      debugPrint('dice date $now');
      return DateTime.now().millisecondsSinceEpoch +
          100 * now.difference(updatedAt).inSeconds;
    } catch (error, st) {
      return 0;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'credits': credits,
      'loops': loops,
      'serverId': serverId,
      'presence': presence,
      'current_slot': currentSlot,
      'dice': dice,
      'challenge_progress': challengeProgress,
      'bonus': bonus.toJson(),
      'premium': premium,
    };
  }

  Map<String, dynamic> toJsonFull() {
    return {
      'id': id,
      'credits': credits,
      'loops': loops,
      'serverId': serverId,
      'presence': presence,
      'current_slot': currentSlot,
      'dice': dice,
      'challenge_progress': challengeProgress,
      'bonus': bonus.toJson(),
      'items': items.toJson(),
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

class Item {
  int kick;
  int step;

  Item({required this.kick, required this.step});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(kick: json['kick'] ?? 0, step: json['step'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'kick': kick, 'step': step};
  }
}
