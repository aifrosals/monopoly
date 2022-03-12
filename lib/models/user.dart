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
  int challengeProgress;
  bool premium;
  Item items;
  String diceUpdatedAt;

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
      required this.items,
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
        diceUpdatedAt: json['dice_updated_at'],
        premium: json['premium'],
        bonus: bonus,
        items: items,
        shield: shield);
  }

  int getItemCount() {
    return items.step + items.kick;
  }

  String getDiceString() {
    if (dice != null) {
      if (dice! <= 2) {
        return '${dice!}/2';
      } else {
        return '2/2 + ${dice! - 2}';
      }
    } else {
      return '0/2';
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
