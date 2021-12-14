import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/user.dart';
import 'package:monopoly/services/connection_status_singleton.dart';

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
    socket.onDisconnect((_) {
      debugPrint('disconnect');
    });
  }

  userConnected(User user) {
    socket.emit('online', user.id);
    debugPrint('Connected');
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
