import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/config/values.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/pages/learn_more_page.dart';
import 'package:monopoly/providers/timer_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/helping_dialog.dart';
import 'package:monopoly/widgets/treasure_hunt_dialog.dart';
import 'package:monopoly/widgets/user_challenge_dialog.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'board_provider.dart';

class SocketProvider extends ChangeNotifier {
  io.Socket socket = io.io(
    ApiConstants.socketPoint,
    <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    },
  );

  // late StreamSubscription _connectionChangeStream;

  bool _activeMove = true;

  List<User> _users = [];

  SocketProvider(User user) {
    // ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    // _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);

    if (user.id == 'user3') {
      socket.io.options['extraHeaders'] = {'token': 'user3'};
    } else {
      socket.io.options['extraHeaders'] = {'token': user.token};
    }
    debugPrint('this is the user ${user.id}');
    // socket.query = json.encode({'token': user.token});

    socket.connect();
    socket.onConnect((data) => userConnected(user));
    socket.on(user.serverId, (data) => updateUser(data));
    socket.on('check_users', (data) => updateSlotPresence(data));
    socket.on('check_board', (data) => updateBoard(data));
    socket.on('buy_land', (data) => notifyBuyLand());
    socket.on('upgrade_slot', (data) => notifyUpgradeSlot(data));
    socket.on('buy_owned_slot', (data) => notifyBuyOwnedSlot(data));
    socket.on('update_current_user', (data) => updateCurrentUser(data));
    socket.on('buy_owned_slot_half', (data) => notifyBuyOwnedSlotHalf(data));
    socket.on('chest', (data) => notifyCommunityChest(data));
    socket.on('reward', (data) => notifyReward(data));
    socket.on('reward_star', (data) => notifyRewardStar(data));
    socket.on('show_rent_message', (data) => showRentMessage(data));
    socket.on('chance', (data) => notifyChance(data));
    socket.on('challenge', (data) => notifyChallenge(data, user));
    socket.on('treasure_hunt', (data) => notifyTreasureHunt(data, user));
    socket.on('end', (data) => notifyBundleReward(data));

    socket.onConnectError((error) {
      debugPrint('socket connection error $error');
      HelpingDialog.showServerResponseDialog('Unknown error occurred');
    });

    socket.onError((error) {
      debugPrint('socket error $error');
      HelpingDialog.showServerResponseDialog(error.toString());
    });

    socket.onDisconnect((_) {
      debugPrint('disconnect');
    });
  }

  userConnected(User user) {
    socket.emit('online', user.id);
    debugPrint('Connected');
  }

  updateUser(dynamic userData) {
    try {
      debugPrint('SocketProvider update user gets called $userData');
      User user = User.fromJson(userData);
      Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
              listen: false)
          .updateUser(user);
    } catch (error, st) {
      debugPrint('update user $error $st');
    } finally {
      notifyListeners();
    }
  }

  notifyBuyLand() {
    try {
      User user = Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
              listen: false)
          .user;
      if (user.credits < 50) {
        HelpingDialog.showNotEnoughCredDialog(50);
        return;
      }
      debugPrint('buy land is triggered');
      debugPrint('buyLand user current slot ${user.currentSlot}');
      showDialog(
          context: Values.navigatorKey.currentContext!,
          builder: (context) => ChangeNotifierProvider(
            create: (context) => TimerProvider(90),
                child: Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer<TimerProvider>(
                          builder: (context, timerProvider, child) {
                        if (timerProvider.time == 0) {
                          Navigator.pop(context);
                        }
                        return Text('time left: ${timerProvider.time}');
                      }),
                      const Text('Buy Land'),
                      const Text('Buy Land for 50 credits'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    HelpingDialog.showLoadingDialog();
                                    debugPrint(
                                        'buyLand user current slot ${user.currentSlot}');
                                    Uri url = Uri.parse(
                                        '${ApiConstants.domain}${ApiConstants.buyLand}');
                                    var body = {
                                      'userId': user.id,
                                      'slotIndex': user.currentSlot
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
                                    Navigator.pop(
                                        Values.navigatorKey.currentContext!);
                                    debugPrint(
                                        'notify buy land ${response.body}');
                                    if (response.statusCode == 200) {
                                      //TODO: remove this repetition and use the function below or remove it
                                      User user = User.fromJson(
                                          json.decode(response.body));
                                      Provider.of<UserProvider>(
                                              Values
                                                  .navigatorKey.currentContext!,
                                              listen: false)
                                          .updateUser(user);
                                      HelpingDialog.showServerResponseDialog(
                                          'Land is purchased');
                                    } else {
                                      HelpingDialog.showServerResponseDialog(
                                          response.body);
                                    }
                                  },
                                  child: const Text('yes')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No')),
                            ]),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LearnMorePage()));
                          },
                          child: const Text('Learn More')),
                    ],
                  ),
                ),
              ));
    } catch (error, st) {
      debugPrint('SocketProvider $error $st');
    }
  }

  notifyUpgradeSlot(dynamic data) {
    debugPrint('notifyUpgradeSlot $data');

    try {
      User user = Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
          listen: false)
          .user;
      debugPrint('upgradeSlot userslot ${user.currentSlot}');
      int price = 0;
      String name = '';
      Slot slot = Slot.fromJson(data);
      int level = slot.level ?? 100;

      // TODO: remove this logic from here and add it in the slot class
      switch (level) {
        case 0:
          {
            price = 100;
            name = 'House';
          }
          break;
        case 1:
          {
            price = 200;
            name = 'Shop';
          }
          break;
        case 2:
          {
            price = 400;
            name = 'Condo';
          }
          break;
        case 3:
          {
            price = 800;
            name = 'Business center or a Theme Park';
          }
          break;
        case 4:
          {
            price = 1600;
            name = "city";
          }
          break;
        default:
          {}
          break;
      }

      if (user.credits < price) {
        HelpingDialog.showNotEnoughCredUpgradeDialog(price);
        return;
      }
      showDialog(
          context: Values.navigatorKey.currentContext!,
          builder: (context) => ChangeNotifierProvider(
            create: (context) => TimerProvider(90),
                child: Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer<TimerProvider>(
                          builder: (context, timerProvider, child) {
                        if (timerProvider.time == 0) {
                          Navigator.pop(context);
                        }
                        return Text('Timer left: ${timerProvider.time}');
                      }),
                      const Text('Upgrade or Sell'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  HelpingDialog.showLoadingDialog();
                                  debugPrint(
                                      'upgradeSlot userslot ${user.currentSlot}');
                                  Uri url = Uri.parse(
                                      '${ApiConstants.domain}${ApiConstants.upgradeSlot}');
                                  var body = {
                                    'userId': user.id,
                                    'slotIndex': user.currentSlot,
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
                                  Navigator.pop(
                                      Values.navigatorKey.currentContext!);
                                  debugPrint(
                                      'notifyUpgradeSlot ${response.body}');
                                  if (response.statusCode == 200) {
                                    //TODO: remove this repetition and use the function below or remove it
                                    User user = User.fromJson(
                                        json.decode(response.body));
                                    Provider.of<UserProvider>(
                                            Values.navigatorKey.currentContext!,
                                            listen: false)
                                        .updateUser(user);
                                    HelpingDialog.showServerResponseDialog(
                                        'Place Upgraded Successfully');
                                  } else {
                                    HelpingDialog.showServerResponseDialog(
                                        response.body);
                                  }
                                },
                                child: Text(
                                  'Upgrade this place into a $name for $price credits',
                                  textAlign: TextAlign.center,
                                ),
                                style:
                                    TextButton.styleFrom(primary: Colors.green),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  HelpingDialog.showLoadingDialog();
                                  debugPrint('sell Urgent ${user.currentSlot}');
                                  Uri url = Uri.parse(
                                      '${ApiConstants.domain}${ApiConstants.urgentSell}');
                                  var body = {
                                    'userId': user.id,
                                    'slotIndex': user.currentSlot,
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
                                  debugPrint(
                                      'notifyUpgradeSlot sell Urgently ${response.body}');
                                  Navigator.pop(
                                      Values.navigatorKey.currentContext!);
                                  if (response.statusCode == 200) {
                                    HelpingDialog.showServerResponseDialog(
                                        response.body);
                                  } else {
                                    HelpingDialog.showServerResponseDialog(
                                        response.body);
                                  }
                                },
                                child: const Text(
                                  'Sell Urgently',
                                  textAlign: TextAlign.center,
                                ),
                                style:
                                    TextButton.styleFrom(primary: Colors.blue),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Do Nothing')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LearnMorePage()));
                                  },
                                  child: const Text('Learn More')),
                            ]),
                      )
                    ],
                  ),
                ),
              ));
    } catch (error, st) {
      debugPrint('SocketProvider $error $st');
    }
  }

  notifyBuyOwnedSlot(dynamic data) {
    debugPrint('notifyBuyOwnedSlot $data');

    Slot slot = Slot.fromJson(data['slot']);
    User owner = User.fromJson(data['owner']);
    User user = Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
        listen: false)
        .user;

    debugPrint('Slot type ${slot.type}');

    int sellingFactor = getSellingFactor(slot.level ?? 100);
    int sellingPrice = 0;
    if (slot.updatedPrice != null) {
      sellingPrice = slot.updatedPrice! * sellingFactor;
    }

    if (user.credits < sellingPrice) {
      HelpingDialog.showNotEnoughCredDialog(sellingPrice);
      return;
    }
    showDialog(
        context: Values.navigatorKey.currentContext!,
        builder: (context) => ChangeNotifierProvider(
          create: (context) => TimerProvider(90),
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer<TimerProvider>(
                          builder: (context, timerProvider, child) {
                        if (timerProvider.time == 0) {
                          Navigator.pop(context);
                        }
                        return Text('Time left: ${timerProvider.time}');
                      }),
                      Text(
                        'Do you want to buy this Property from ${owner.id} for $sellingPrice?',
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                HelpingDialog.showLoadingDialog();
                                Uri url = Uri.parse(
                                    '${ApiConstants.domain}${ApiConstants.buyProperty}');
                                var body = {
                                  'userId': user.id,
                                  'slotIndex': user.currentSlot,
                                };
                                var response = await http.post(
                                  url,
                                  body: json.encode(body),
                                  //TODO: add token
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'x-access-token': user.token ?? ''
                                  },
                                );
                                debugPrint('notify buy land ${response.body}');

                                Navigator.pop(
                                    Values.navigatorKey.currentContext!);
                                if (response.statusCode == 200) {
                                  //TODO: remove this repetition and use the function below or remove it
                                  User user =
                                      User.fromJson(json.decode(response.body));
                                  Provider.of<UserProvider>(
                                          Values.navigatorKey.currentContext!,
                                          listen: false)
                                      .updateUser(user);
                                  HelpingDialog.showServerResponseDialog(
                                      'Property Purchased Successfully');
                                } else {
                                  HelpingDialog.showServerResponseDialog(
                                      response.body);
                                }
                              },
                              child: const Text('Yes')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No'))
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LearnMorePage()));
                          },
                          child: const Text('Learn More')),
                    ],
                  ),
                ),
              ),
            ));
  }

  notifyBuyOwnedSlotHalf(dynamic data) {
    debugPrint('notifyBuyOwnedSlot $data');

    Slot slot = Slot.fromJson(data['slot']);
    User owner = User.fromJson(data['owner']);
    User user = Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
        listen: false)
        .user;

    debugPrint('Slot type ${slot.type}');

    int sellingFactor = getSellingFactor(slot.level ?? 100);
    int sellingPrice = 0;
    if (slot.updatedPrice != null) {
      sellingPrice = (slot.updatedPrice! * sellingFactor) ~/ 2;
    }

    if (user.credits < sellingPrice) {
      HelpingDialog.showNotEnoughCredDialog(sellingPrice);
      return;
    }

    showDialog(
        context: Values.navigatorKey.currentContext!,
        builder: (context) => ChangeNotifierProvider(
          create: (context) => TimerProvider(90),
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer<TimerProvider>(
                          builder: (context, timerProvider, child) {
                        if (timerProvider.time == 0) {
                          Navigator.pop(context);
                        }
                        return Text('Time left: ${timerProvider.time}');
                      }),
                      Text(
                        'Do you want to buy this Property from ${owner.id} for $sellingPrice credits (half)?',
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                HelpingDialog.showLoadingDialog();
                                Uri url = Uri.parse(
                                    '${ApiConstants.domain}${ApiConstants.buyPropertyHalf}');
                                var body = {
                                  'userId': user.id,
                                  'slotIndex': user.currentSlot,
                                };
                                var response = await http.post(
                                  url,
                                  body: json.encode(body),
                                  //TODO: add token
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'x-access-token': user.token ?? ''
                                  },
                                );
                                debugPrint('notify buy land ${response.body}');

                                Navigator.pop(
                                    Values.navigatorKey.currentContext!);

                                if (response.statusCode == 200) {
                                  //TODO: remove this repetition and use the function below or remove it
                                  User user =
                                      User.fromJson(json.decode(response.body));
                                  Provider.of<UserProvider>(
                                          Values.navigatorKey.currentContext!,
                                          listen: false)
                                      .updateUser(user);
                                  HelpingDialog.showServerResponseDialog(
                                      'Property Purchased Successfully');
                                } else {
                                  HelpingDialog.showServerResponseDialog(
                                      response.body);
                                }
                              },
                              child: const Text('Yes')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No'))
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LearnMorePage()));
                          },
                          child: const Text('Learn More')),
                    ],
                  ),
                ),
              ),
            ));
  }

  notifyCommunityChest(dynamic data) {
    HelpingDialog.showServerResponseDialog(data.toString());
  }

  notifyReward(dynamic data) {
    HelpingDialog.showServerResponseDialog(data.toString());
  }

  notifyRewardStar(dynamic data) {
    HelpingDialog.showServerResponseDialog(
        'You have gained a star. Get 5 stars and receive RM reward.');
  }

  notifyChallenge(dynamic data, User user) {
    try {
      showDialog(
          context: Values.navigatorKey.currentContext!,
          builder: (context) => UserChallengeDialog(user: user));
    } catch (error, st) {
      debugPrint('notifyChallenge error $error $st');
    }
  }

  notifyTreasureHunt(dynamic data, User user) {
    try {
      showDialog(
          barrierDismissible: false,
          context: Values.navigatorKey.currentContext!,
          builder: (context) => TreasureHuntDialog(user: user));
    } catch (error, st) {
      debugPrint('notifyTreasureHunt error $error $st');
    }
  }

  notifyBundleReward(dynamic data) {
    HelpingDialog.showServerResponseDialog(
        'Congratulations! You have gained 150 credits, 1 item and 5 RM cash');
  }

  updateBoard(dynamic data) {
    debugPrint('updateBoard data received $data');
    Provider.of<BoardProvider>(Values.navigatorKey.currentContext!,
            listen: false)
        .updateBoardSlots(data);
  }

  updateSlotPresence(dynamic data) {
    try {
      debugPrint('User slot presence is updated $data');
      data as List;
      _users = data.map((e) => User.fromJson(e)).toList();
      _users.removeWhere((element) => element.presence == 'online');
    } catch (error, st) {
      debugPrint('$error $st');
    } finally {
      notifyListeners();
    }
  }

  updateUserCurrentSlot(User user, int diceFace) {
    debugPrint('userMove user ${user.toJson()}');
    _activeMove = false;
    var userData = {'user': user.toJson(), 'diceFace': diceFace};
    socket.emit('userMove', userData);
    notifyListeners();
  }

  moveBack(User user) {
    debugPrint('users prev step ${user.currentSlot}');
    var userData = user.toJson();
    socket.emit('moveBack', userData);
  }

  updateUserCurrentSlotNotDice(User user) {
    debugPrint('userMove user ${user.toJson()}');
    _activeMove = false;
    var userData = {'user': user.toJson()};
    socket.emit('userMove', userData);
    notifyListeners();
  }

  notifyChance(dynamic data) async {
    debugPrint('notifyChance data $data');
    try {
      User user = User.fromJson(data['ur']);
      var result = data['response'];
      //updateCurrentUser(data['ur']);
      if (result['effect'] == 'challenge') {
        _activeMove = false;
        notifyListeners();
        User user2 = await Provider.of<BoardProvider>(
                Values.navigatorKey.currentContext!,
                listen: false)
            .chanceChallengeEffect(user);
        updateUserCurrentSlotNotDice(user2);
      } else {
        HelpingDialog.showServerResponseDialog(result['message']);
      }
    } catch (error, st) {
      debugPrint('notifyChance error $error $st');
    }
  }

  disableMove() {
    _activeMove = false;
    notifyListeners();
  }

  enableMove() {
    _activeMove = true;
  }

  // blackHoleEffect(dynamic slot) {
  //   try {
  //     debugPrint('blackHoleEffect reached $slot');
  //     Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
  //             listen: false)
  //         .setCurrentSlotServer(slot);
  //     updateUserCurrentSlot(Provider.of<UserProvider>(
  //             Values.navigatorKey.currentContext!,
  //             listen: false)
  //         .user);
  //   } catch (error, st) {
  //     debugPrint('SocketProvider blackHoleEffect $error $st');
  //   }
  // }

  getOfflineUsers(int slot) {
    int currentSlotUsers = 0;
    for (var user in _users) {
      if (slot == user.currentSlot) {
        currentSlotUsers = currentSlotUsers + 1;
      }
    }
    return currentSlotUsers;
  }

  getOfflineUserData(int slot) {
    List<User> selectedSlotUsers = [];
    for (var user in _users) {
      if (slot == user.currentSlot) {
        selectedSlotUsers.add(user);
      }
    }
    return selectedSlotUsers;
  }

  updateCurrentUser(dynamic userData) {
    _activeMove = true;
    try {
      debugPrint('SocketProvider update current user gets called $userData');
      User user = User.fromJson(userData);
      Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
              listen: false)
          .updateUser(user);
    } catch (error, st) {
      debugPrint('update current user $error $st');
    } finally {
      notifyListeners();
    }
  }

  showRentMessage(dynamic data) {
    try {
      // Provider.of<BoardProvider>(Values.navigatorKey.currentContext!,
      //         listen: false)
      //     .showMessage(data);

      HelpingDialog.showServerResponseDialog('You have paid $data rent');

      final player = AudioCache();

      player.play('sounds/rent_paid.wav');
    } catch (error, st) {
      debugPrint('SocketProvider showRentMessage error $error $st');
    }
  }

  disconnect() {
    socket.disconnect();
    socket.dispose();
  }

  // connectionChanged(dynamic hasConnection) {
  //  debugPrint('internet connection test $hasConnection');
  // }

  int getSellingFactor(int level) {
    switch (level) {
      case 0:
        {
          return 20;
        }
      case 1:
        {
          return 15;
        }
      case 2:
        {
          return 10;
        }
      case 3:
        {
          return 8;
        }
      case 4:
        {
          return 6;
        }
      case 5:
        {
          return 4;
        }
      default:
        {
          return 1;
        }
    }
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  List<User> get users => _users;

  bool get activeMove => _activeMove;
}
