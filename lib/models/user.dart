class User {
  String id;
  int? currentSlot;
  int dice;
  int credits;
  int loops;
  bool presence;

  User(
      {required this.id,
      required this.credits,
      required this.dice,
      required this.loops,
      required this.presence,
      this.currentSlot});
}
