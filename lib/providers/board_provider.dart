import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/config/screen_config.dart';
import 'package:monopoly/config/values.dart';
import 'package:monopoly/models/slot.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/models/user.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/helping_dialog.dart';
import 'package:provider/provider.dart';

class BoardProvider extends ChangeNotifier {
  final _scrollController = ScrollController();

  final _characterKey = GlobalKey();

  final _staticCharacterKey = GlobalKey();

  final double _kSlotHeight = 108.0;

  bool _isCharacterStatic = true;

  bool _isItemListVisible = false;

  bool _isItemEffectActive = false;

  List<Slot> _slots = [];

  double _characterWidth = 100;

  double _characterHeight = 100;

  bool _isScrollOptionVisible = false;

// value for test purpose
//  int _characterIndex = 0;

  double _characterTop = 0;

  double _showMessageOpacity = 0;

  String _message = '';

  /* Method for testing
  setCharacterIndex(int number) {
    int slot = _characterIndex + number;
    if (slot > 16) {
      _characterIndex = slot - 17;

    } else {
      _characterIndex = slot;
    }

    notifyListeners();
  }*/

  showScrollOption() {
    _isScrollOptionVisible = true;
    notifyListeners();
  }

  hideScrollOption() {
    _isScrollOptionVisible = false;
    notifyListeners();
  }

  setScroll() {
    debugPrint('set scroll is working');
    if (_staticCharacterKey.currentContext != null) {
      Scrollable.ensureVisible(_staticCharacterKey.currentContext!,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOut,
          alignment: 0.2);
      debugPrint('Scroll offset ${_scrollController.position.pixels}');
      setCharacterPositionAtBinding(_scrollController.position.pixels);
    }
  }

  setEffectScroll(int number, String effect) async {
    switch (effect) {
      case 'black_hole':
        {
          _characterTop = _characterTop - (_kSlotHeight * number);
          notifyListeners();
        }
        break;
      case 'worm_hole':
        {
          _characterTop = _characterTop + (_kSlotHeight * number);
          notifyListeners();
        }
        break;
    }

    await Future.delayed(const Duration(seconds: 1));
    if (_characterKey.currentContext != null) {
      await Scrollable.ensureVisible(_characterKey.currentContext!,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
          alignment: 0.2);
    }

    _isCharacterStatic = true;
    notifyListeners();
  }

  animateA(
    int number,
  ) async {
    _isCharacterStatic = false;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));

    for (int i = 0; i < number; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      _characterTop = _characterTop + _kSlotHeight;
      notifyListeners();
      final player = AudioCache();
      await Future.delayed(const Duration(milliseconds: 500));

      if (_slots.last.endKey != null && _characterKey.currentContext != null) {
        RenderBox box2 =
            _slots.last.endKey!.currentContext?.findRenderObject() as RenderBox;
        Offset position2 = box2.localToGlobal(Offset.zero);
        debugPrint(
            'end position ${position2.direction} ${position2.dx} ${position2.dy} ${position2.distance}');
        debugPrint('character top $_characterTop');

        RenderBox box =
            _characterKey.currentContext!.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        debugPrint('char position ${position.dy}');

        if (position.dy > position2.dy + 20) {
          debugPrint('Condition is true');
          _characterTop = 15;
          notifyListeners();
          _scrollController.animateTo(0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
        if (_characterKey.currentContext != null) {
          debugPrint('condition is not true');
          Scrollable.ensureVisible(_characterKey.currentContext!,
              duration: const Duration(milliseconds: 500),
              alignment: 0.2,
              curve: Curves.easeOut);
        }
      }
      player.play('sounds/movement_2.mp3');
      Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
              listen: false)
          .incrementCredits();
    }

    _isCharacterStatic = true;
    notifyListeners();
  }

  setCharacterPositionAtBinding(double scrollOffset) {
    debugPrint('binding gets called');
    RenderBox box2 =
        _staticCharacterKey.currentContext?.findRenderObject() as RenderBox;
    Offset position2 = box2.localToGlobal(Offset.zero);
    debugPrint(
        'static position ${position2.direction} ${position2.dx} ${position2.dy} ${position2.distance}');
    double topPadding =
        ScreenConfig.paddingTop != 0.0 ? 56 + ScreenConfig.paddingTop : 85;
    if (scrollOffset != 0.0) {
      _characterTop = position2.dy + scrollOffset - topPadding;
    } else {
      _characterTop = position2.dy - topPadding;
    }
    debugPrint('character top $characterTop');
    notifyListeners();
  }

  Future<Map<String, dynamic>> getBoardSlots(User user) async {
    try {
      debugPrint('called');
      Uri url = Uri.parse('${ApiConstants.domain}${ApiConstants.slots}');
      // var body = {'id': id};
      debugPrint('$url');
      var response = await http.get(
        url,
        // body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': user.id == 'user3' ? 'user3' : user.token ?? ''
        },
      );
      debugPrint('BoardProvider getBoardSlots ${response.body}');
      if (response.statusCode == 200) {
        var resData = json.decode(response.body) as List;
        _slots = resData.map((e) => Slot.fromJson(e)).toList();
        Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
                listen: false)
            .setSlotSize(_slots.length);
        return {
          'status': true,
        };
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403 ||
          response.statusCode == 405) {
        return {'status': false, 'message': response.body};
      } else {
        return {
          'status': false,
          'message': 'Unknown server error ${response.statusCode}'
        };
      }
    } catch (error, st) {
      debugPrint('BoardProvider $error $st');
      return {'status': false, 'message': 'Unknown error'};
    } finally {
      notifyListeners();
    }
  }

  updateBoardSlots(dynamic data) {
    try {
      data as List;
      _slots = data.map((e) => Slot.fromJson(e)).toList();
      debugPrint('slots data ${_slots[9]}');
    } catch (error, st) {
      debugPrint('BoardProvider updateBoardSlots $error $st');
    } finally {
      notifyListeners();
    }
  }

  //TODO: Either remove or use with delay animations
  Future<User> checkSlotEffect(User user) async {
    if (user.currentSlot != null) {
      Slot slot = _slots[user.currentSlot!];
      //  Slot slot = _slots[_characterIndex];
      switch (slot.type) {
        case 'black_hole':
          {
            user = await blackHoleEffect(user);
          }
          break;
        case 'worm_hole':
          {
            user = await wormHoleEffect(user);
          }
      }
    }
    notifyListeners();
    //await Future.delayed(Duration(seconds: 1));
    //setScroll();
    //setScrollRevers();
    return user;
  }

  Future<User> blackHoleEffect(User user) async {
    _isCharacterStatic = false;
    _characterHeight = 0;
    _characterWidth = 0;
    notifyListeners();
    final player = AudioCache();
    player.play('sounds/teleport_in.wav');
    await Future.delayed(const Duration(seconds: 1));

    /// randomly push to previous slot
    Random random = Random();
    int limit = user.currentSlot! - 1;
    //int limit = _characterIndex - 1;
    int randomPreviousSlot = random.nextInt(limit);
    // int moveOffset = _characterIndex - randomPreviousSlot;
    int moveOffset = user.currentSlot! - randomPreviousSlot;
    user.currentSlot = randomPreviousSlot;
    //_characterIndex = randomPreviousSlot;
    setEffectScroll(moveOffset, 'black_hole');
    await Future.delayed(const Duration(seconds: 1));
    _characterHeight = 0;
    _characterWidth = 0;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _characterHeight = 25;
    _characterWidth = 25;
    notifyListeners();
    return user;
  }

  Future<User> wormHoleEffect(User user) async {
    _isCharacterStatic = false;
    _characterHeight = 0;
    _characterWidth = 0;
    notifyListeners();
    final player = AudioCache();
    player.play('sounds/teleport_in.wav');
    await Future.delayed(const Duration(seconds: 1));
    Random random = Random();
    int max = _slots.length;
    int min = user.currentSlot! + 1;
    //  int min = _characterIndex + 1;
    int randomNextSlot = min + random.nextInt(max - min);
    // int moveOffset = (_characterIndex - randomNextSlot).abs();
    int moveOffset = (user.currentSlot! - randomNextSlot).abs();
    debugPrint('worm_hole move offset $moveOffset');
    user.currentSlot = randomNextSlot;
    // _characterIndex = randomNextSlot;
    setEffectScroll(moveOffset, 'worm_hole');

    await Future.delayed(const Duration(seconds: 2));
    _characterHeight = 25;
    _characterWidth = 25;
    notifyListeners();
    return user;
  }

  Future<User> chanceChallengeEffect(User user) async {
    Slot challengeSlot =
        _slots.firstWhere((element) => element.type == 'challenge');
    user.currentSlot = challengeSlot.index;
    Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
            listen: false)
        .updateUser(user);
    await Future.delayed(const Duration(milliseconds: 500));
    setScroll();
    return user;
  }

  Future<void> showMessage(dynamic data) async {
    _showMessageOpacity = 1;
    _message = 'you have paid $data rent';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 3000));
    _showMessageOpacity = 0;
    notifyListeners();
  }

  Future<void> kickUser(User user) async {
    try {
      _isItemEffectActive = true;
      notifyListeners();

      Uri url = Uri.parse('${ApiConstants.domain}${ApiConstants.kickUser}');
      var body = {
        'id': user.serverId,
      };
      debugPrint('$url');
      var response = await http.post(
        url,
        body: json.encode(body),
        //TODO: add token
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': user.token ?? ''
        },
      );
      if (response.statusCode == 200) {
        HelpingDialog.showServerResponseDialog("A user is kicked");
        var data = json.decode(response.body);
        User user = User.fromJson(data);
        Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
                listen: false)
            .updateUser(user);
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403 ||
          response.statusCode == 405) {
        HelpingDialog.showServerResponseDialog(response.body);
      } else {
        HelpingDialog.showServerResponseDialog('Server Error');
      }
    } catch (error, st) {
      debugPrint('kick user error $error $st');
      HelpingDialog.showServerResponseDialog('Unknown error');
    } finally {
      _isItemEffectActive = false;
      notifyListeners();
    }
  }

  Future<bool> useStep(User user) async {
    try {
      _isItemEffectActive = true;
      notifyListeners();

      Uri url = Uri.parse('${ApiConstants.domain}${ApiConstants.useStep}');
      var body = {
        'id': user.serverId,
      };
      debugPrint('$url');
      var response = await http.post(
        url,
        body: json.encode(body),
        //TODO: add token
        headers: {
          'Content-Type': 'application/json',
          'x-access-token': user.token ?? ''
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        User user = User.fromJson(data);
        Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
                listen: false)
            .updateUser(user);
        return true;
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 402 ||
          response.statusCode == 403 ||
          response.statusCode == 405) {
        HelpingDialog.showServerResponseDialog(response.body);
        return false;
      } else {
        HelpingDialog.showServerResponseDialog('Server Error');
        return false;
      }
    } catch (error, st) {
      debugPrint('kick user error $error $st');
      HelpingDialog.showServerResponseDialog('Unknown error');
      return false;
    } finally {
      _isItemEffectActive = false;
      notifyListeners();
    }
  }

  hideMessage() {
    _showMessageOpacity = 0;
    notifyListeners();
  }

  showItemList() {
    _isItemListVisible = true;
    notifyListeners();
  }

  hideItemList() {
    _isItemListVisible = false;
    notifyListeners();
  }


  getWidgetImage() {
    return Positioned(
      child: Text('hello'),
    );
  }

  List<Icon> getRewardStars(int? count) {
    List<Icon> stars = [];
    if (count != null) {
      for (int i = 0; i < count; i++) {
        stars.add(const Icon(
          Icons.star,
          size: 7,
          color: Colors.yellow,
        ));
      }
    }
    return stars;
  }

  List<Slot> get slots => _slots;

  double get characterHeight => _characterHeight;

  double get characterWidth => _characterWidth;

  double get characterTop => _characterTop;

  double get showMessageOpacity => _showMessageOpacity;

  String get message => _message;

  ScrollController get scrollController => _scrollController;

  GlobalKey get characterKey => _characterKey;

  GlobalKey get staticCharacterKey => _staticCharacterKey;

  bool get isCharacterStatic => _isCharacterStatic;

  bool get isItemListVisible => _isItemListVisible;

  bool get isItemEffectActive => _isItemEffectActive;

  double get kSlotHeight => _kSlotHeight;

  bool get isScrollOptionVisible => _isScrollOptionVisible;
}
