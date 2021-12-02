import 'package:flutter/cupertino.dart';
import 'package:monopoly/models/user.dart';

class UserProvider extends ChangeNotifier {

  final _scrollController = ScrollController();

  final User _user = User(
      presence: 'offline',
      loops: 0,
      dice: 5,
      credits: 0,
      id: 'user1',
      currentSlot: 0);

  login(String id) {
    _user.id = id;
    notifyListeners();
  }

  setCurrentSlot(int diceFace) {
    if (_user.currentSlot != null) {
      _user.currentSlot = _user.currentSlot! + diceFace;
      _scrollController.animateTo(60.0 * _user.currentSlot!,
          duration: const Duration(milliseconds: 1500), curve: Curves.easeOut);
    }

    notifyListeners();
  }

  User get user => _user;
  ScrollController get scrollController => _scrollController;
}