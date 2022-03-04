import 'dart:math';

enum Directions { east, west, south, north }

extension DirectionGnerator on Directions {
  static List<Directions> generateRandomDirections(int n) {
    var rnd = Random();
    return List.generate(
        n, (i) => Directions.values[rnd.nextInt(Directions.values.length)]);
  }
}

extension ParseToString on Directions {
  String toShortString() {
    return toString().split('.').last;
  }
}
