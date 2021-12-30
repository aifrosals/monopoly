import 'dart:math';

class SlotNames {
  static List<String> names = ['Business Center', 'Theme Park'];

  static String getRandomName() {
    Random random = Random();
    int i = random.nextInt(1);
    return names[i];
  }
}
