import 'dart:convert';

import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/config/screen_config.dart';
import 'package:monopoly/config/values.dart';
import 'package:monopoly/models/slot.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/models/user.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BoardProvider extends ChangeNotifier {
  final _scrollController = ScrollController();

  final _characterKey = GlobalKey();

  final _staticCharacterKey = GlobalKey();

  bool _isCharacterStatic = true;

  List<Slot> _slots = [];
  double _characterWidth = 30;
  double _characterHight = 30;

// value for test purpose
//  int _characterIndex = 0;

  double _characterTop = 15;

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

  setScroll() {
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
          _characterTop = _characterTop - (90 * number);
          notifyListeners();
        }
        break;
      case 'worm_hole':
        {
          _characterTop = _characterTop + (90 * number);
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
      _characterTop = _characterTop + 90;
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
          _characterTop = 15;
          notifyListeners();
          _scrollController.animateTo(0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
        if (_characterKey.currentContext != null) {
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

  getBlockHeight() {
    debugPrint('height of screen ${ScreenConfig.blockHeight}');
    debugPrint('dpi of screen ${ScreenConfig.dpi}');
    debugPrint('appbar height of the screen ${ScreenConfig.appBarHeight}');
    debugPrint('top padding ${ScreenConfig.paddingTop}');
  }

  getBoardSlots() async {
    try {
      debugPrint('called');
      Uri url = Uri.parse('${ApiConstants.domain}${ApiConstants.slots}');
      // var body = {'id': id};
      debugPrint('$url');
      var response = await http.get(
        url,
        // body: json.encode(body),
        //TODO: Create jwt on server
        headers: {
          'Content-Type': 'application/json'
          // HttpHeaders.authorizationHeader: 'Bearer ${user.token}'
          //'${user.token}',
        },
      );
      debugPrint('BoardProvider getBoardSlots ${response.body}');
      var resData = json.decode(response.body) as List;
      _slots = resData.map((e) => Slot.fromJson(e)).toList();
      //  user.id = id;
      //   user.currentSlot = resData['current_slot'];

    } catch (error, st) {
      debugPrint('BoardProvider $error $st');
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
    notifyListeners();
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
    return user;
  }

  Future<User> wormHoleEffect(User user) async {
    _isCharacterStatic = false;
    notifyListeners();
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

  hideMessage() {
    _showMessageOpacity = 0;
    notifyListeners();
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

  double get characterHight => _characterHight;

  double get characterWidth => _characterWidth;

  double get characterTop => _characterTop;

  double get showMessageOpacity => _showMessageOpacity;

  String get message => _message;

  // int get characterIndex => _characterIndex;

  ScrollController get scrollController => _scrollController;

  GlobalKey get characterKey => _characterKey;

  GlobalKey get staticCharacterKey => _staticCharacterKey;

  bool get isCharacterStatic => _isCharacterStatic;
}

