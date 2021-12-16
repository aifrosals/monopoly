import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/config/values.dart';
import 'package:monopoly/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketProvider extends ChangeNotifier {
  io.Socket socket = io.io(ApiConstants.socketPoint, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  // late StreamSubscription _connectionChangeStream;

  List<User> _users = [];

  SocketProvider(User user) {
    // ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    // _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);

    debugPrint('this is the user ${user.id}');
    socket.connect();
    socket.onConnect((data) => userConnected(user));
    // socket.emit('online', user.id);
    socket.on('checkUsers', (data) => updateSlotPresence(data));
    socket.on('buy_land', (data) => notifyBuyLand(user));
    socket.onDisconnect((_) {
      debugPrint('disconnect');
    });
  }

  userConnected(User user) {
    socket.emit('online', user.id);
    debugPrint('Connected');
  }

  notifyBuyLand(User user) {
    //TODO: smooth the flow of dialog with prevention of closing
    try {
      debugPrint('buy land is triggered');
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
                                    User user = User.fromJson(
                                        json.decode(response.body));
                                    Provider.of<UserProvider>(
                                            Values.navigatorKey.currentContext!,
                                            listen: false)
                                        .updateUser(user);
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                              child: Text('Land is purchased'),
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
    socket.emit('userMove', user.toJson());
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

  disconnect() {
    socket.disconnect();
    socket.dispose();
  }

  // connectionChanged(dynamic hasConnection) {
  //  debugPrint('internet connection test $hasConnection');
  // }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  List<User> get users => _users;
}
