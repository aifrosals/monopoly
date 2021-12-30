import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/config/values.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/models/slot_names.dart';
import 'package:monopoly/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

import 'board_provider.dart';

class SocketProvider extends ChangeNotifier {
  io.Socket socket = io.io(ApiConstants.socketPoint, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  // late StreamSubscription _connectionChangeStream;

  bool _activeMove = true;

  List<User> _users = [];

  SocketProvider(User user) {
    // ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    // _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);

    debugPrint('this is the user ${user.id}');
    socket.connect();
    socket.onConnect((data) => userConnected(user));
    socket.on('checkUsers', (data) => updateSlotPresence(data));
    socket.on('checkBoard', (data) => updateBoard(data));
    socket.on('buy_land', (data) => notifyBuyLand());
    socket.on('upgrade_slot', (data) => notifyUpgradeSlot(data));
    socket.on('buy_owned_slot', (data) => notifyBuyOwnedSlot(data));
    socket.on('update_current_user', (data) => updateCurrentUser(data));
    socket.onDisconnect((_) {
      debugPrint('disconnect');
    });
  }

  userConnected(User user) {
    socket.emit('online', user.id);
    debugPrint('Connected');
  }

  notifyBuyLand() {
    //TODO: smooth the flow of dialog with prevention of closing
    try {
      User user = Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
              listen: false)
          .user;
      debugPrint('buy land is triggered');
      debugPrint('buyLand user current slot ${user.currentSlot}');
      showDialog(
          context: Values.navigatorKey.currentContext!,
          builder: (context) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Buy Land'),
                    const Text('Buy Land for 50 credits'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () async {
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
                                      'Content-Type': 'application/json'
                                      // HttpHeaders.authorizationHeader: 'Bearer ${user.token}'
                                      //'${user.token}',
                                    },
                                  );
                                  debugPrint(
                                      'notify buy land ${response.body}');
                                  if (response.statusCode == 200) {
                                    //TODO: remove this repetition and use the function below or remove it
                                    User user = User.fromJson(
                                        json.decode(response.body));
                                    Provider.of<UserProvider>(
                                        Values.navigatorKey.currentContext!,
                                        listen: false)
                                        .updateUser(user);
                                    showDialog(
                                        context: context,
                                        builder: (context) => const Dialog(
                                          child: Text(
                                                'Land is purchased',
                                                textAlign: TextAlign.center,
                                              ),
                                            ));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Text(response.body),
                                        ));
                                  }
                                },
                                child: const Text('yes')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No')),
                          ]),
                    )
                  ],
                ),
              ));
    } catch (error, st) {
      debugPrint('SocketProvider $error $st');
    }
  }

  notifyUpgradeSlot(dynamic data) {
    //TODO: smooth the flow of dialog with prevention of closing
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

      showDialog(
          context: Values.navigatorKey.currentContext!,
          builder: (context) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Upgrade or Sell'),
                    // Text(
                    //   'Upgrade this place into a $name for $price credits?',
                    //   textAlign: TextAlign.center,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () async {
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
                                      'Content-Type': 'application/json'
                                      // HttpHeaders.authorizationHeader: 'Bearer ${user.token}'
                                      //'${user.token}',
                                    },
                                  );
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
                                    showDialog(
                                        context: context,
                                        builder: (context) => const Dialog(
                                              child: Text(
                                                'Place upgraded successfully',
                                                textAlign: TextAlign.center,
                                            ),
                                          ));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                            child: Text(response.body),
                                          ));
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
                                    'Content-Type': 'application/json'
                                    // HttpHeaders.authorizationHeader: 'Bearer ${user.token}'
                                    //'${user.token}',
                                  },
                                );
                                debugPrint(
                                    'notifyUpgradeSlot sell Urgently ${response.body}');
                                if (response.statusCode == 200) {
                                  //TODO: remove this repetition and use the function below or remove it
                                  User user =
                                      User.fromJson(json.decode(response.body));
                                  Provider.of<UserProvider>(
                                          Values.navigatorKey.currentContext!,
                                          listen: false)
                                      .updateUser(user);
                                  showDialog(
                                      context: context,
                                      builder: (context) => const Dialog(
                                            child: Text(
                                              'Place upgraded successfully',
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                            child: Text(response.body),
                                          ));
                                }
                              },
                              child: const Text(
                                'Sell Urgently',
                                textAlign: TextAlign.center,
                              ),
                              style: TextButton.styleFrom(primary: Colors.blue),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Do Nothing')),
                          ]),
                    )
                  ],
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

    showDialog(
        context: Values.navigatorKey.currentContext!,
        builder: (context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Do you want to buy this ${slot.name} from ${owner.id} for $sellingPrice?'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () async {
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
                                  'Content-Type': 'application/json'
                                  // HttpHeaders.authorizationHeader: 'Bearer ${user.token}'
                                  //'${user.token}',
                                },
                              );
                              debugPrint('notify buy land ${response.body}');

                              Navigator.pop(context);
                            },
                            child: const Text('Yes')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'))
                      ],
                    )
                  ],
                ),
              ),
            ));
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

  updateUserCurrentSlot(User user) {
    debugPrint('userMove user ${user.toJson()}');
    _activeMove = false;
    socket.emit('userMove', user.toJson());
    notifyListeners();
  }

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
