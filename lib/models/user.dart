class User {
  String id;
  int? currentSlot;
  int dice;
  int credits;
  int loops;
  String presence;

  User(
      {required this.id,
      required this.credits,
      required this.dice,
      required this.loops,
      required this.presence,
      this.currentSlot});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      credits: json['credits'] ?? 0,
      dice: json['dice'] ?? 0,
      loops: json['loops'] ?? 0,
      presence: json['presence'] ?? 'none',
      currentSlot: json['current_slot'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'credits': credits,
      'loops': loops,
      'presence': presence,
      'current_slot': currentSlot,
      'dice': dice,
    };
  }
}
