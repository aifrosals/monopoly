import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/config/values.dart';
import 'package:monopoly/enums/direction.dart';
import 'package:monopoly/enums/treasure_state.dart';
import 'package:monopoly/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/helping_dialog.dart';
import 'package:provider/provider.dart';

class TreasureHuntProvider extends ChangeNotifier {
  static const int maxDirections = 6;

  TreasureHuntStates _treasureHuntState = TreasureHuntStates.postHunt;

  final List<Directions> _directions =
      DirectionGnerator.generateRandomDirections(maxDirections);
  List<Directions> _answeredDirections = [];
  int _turn = 0;
  String _message = '';

  TreasureHuntProvider() {
    // _directions.forEach((element) {
    //   debugPrint('directions $element');
    // });
  }

  setContinueHunt() {
    _treasureHuntState = TreasureHuntStates.hunt;
    _answeredDirections = [];
    notifyListeners();
  }

  bool checkAnswer(Directions direction) {
    if (_directions[_turn] == direction) {
      _answeredDirections.add(direction);
      _turn++;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<void> getRewards(User user) async {
    try {
      _treasureHuntState = TreasureHuntStates.loading;
      notifyListeners();

      Uri url = Uri.parse(
          '${ApiConstants.domain}${ApiConstants.getTreasureHuntReward}');
      var body = {
        'id': user.serverId,
        'rewardFactor': _turn,
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
        User user = User.fromJson(data['user']);
        final player = AudioCache();
        player.play('sounds/coins.mp3');
        HelpingDialog.showServerResponseDialog(data['message']);
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
      debugPrint('getTreasureHuntReward error $error $st');
      HelpingDialog.showServerResponseDialog('Unknown error');
    } finally {
      _treasureHuntState = TreasureHuntStates.result;
      notifyListeners();
    }
  }

  Future<void> lostHunt(User user) async {
    try {
      _treasureHuntState = TreasureHuntStates.loading;
      notifyListeners();

      Uri url =
          Uri.parse('${ApiConstants.domain}${ApiConstants.loseTreasureHunt}');
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
        _message = 'Wrong direction. Sorry you have lost all of your credits.';
        // HelpingDialog.showServerResponseDialog('Wrong direction. Sorry you have lost all of your credits.');
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
      debugPrint('loseTreasureHunt error $error $st');
      HelpingDialog.showServerResponseDialog('Unknown error');
    } finally {
      _treasureHuntState = TreasureHuntStates.result;
      notifyListeners();
    }
  }

  String getRewardText() {
    switch (turn) {
      case 0:
        {
          return '30 credits and 1 item';
        }
      case 1:
        {
          return '130 credits and 3 items';
        }
      case 2:
        {
          return '630 credits and 6 items';
        }
      case 3:
        {
          return '2130 credits and 10 items';
        }
      case 4:
        {
          return '7130 credits and 15 items';
        }
      case 5:
        {
          return '27130 credits and 21 items';
        }
      default:
        {
          return '';
        }
    }
  }

  String getDirectionText() {
    switch (turn) {
      case 0:
        {
          return '1st';
        }
      case 1:
        {
          return '2nd';
        }
      case 2:
        {
          return '3rd';
        }
      case 3:
        {
          return '4th';
        }
      case 4:
        {
          return '5th';
        }
      case 5:
        {
          return '6th';
        }
      default:
        {
          return '';
        }
    }
  }

  TreasureHuntStates get treasureHuntState => _treasureHuntState;

  List<Directions> get directions => _directions;

  List<Directions> get answeredDirections => _answeredDirections;

  int get turn => _turn;

  String get message => _message;
}
