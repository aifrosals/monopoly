import 'package:flutter/material.dart';
import 'package:monopoly/models/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketProvider extends ChangeNotifier {
  io.Socket socket = io.io('http://192.168.10.10:3000/', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  List<User> _users = [];

  SocketProvider(User user) {
    debugPrint('this is the user ${user.id}');
    socket.connect();
    socket.onConnect((data) => debugPrint('Connected'));
    socket.emit('online', user.id);
    socket.on('checkUsers', (data) => updateSlotPresence(data));
    socket.onDisconnect((_) {
      debugPrint('disconnect');
    });
  }

  updateSlotPresence(dynamic data) {
    try {
      debugPrint('data $data');
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

  disconnect() {
    socket.disconnect();
    socket.dispose();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  List<User> get users => _users;
}
