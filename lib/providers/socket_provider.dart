import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketProvider extends ChangeNotifier {
  io.Socket socket = io.io('http://192.168.10.7:3000/', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  SocketProvider() {
    debugPrint('this is reached');

    // socket.onConnecting((_) {
    // debugPrint('connect');
    // socket.emit('msg', 'test');
    // });
    socket.connect();
    socket.onConnect((data) => debugPrint('Connected'));
    socket.onDisconnect((_) => debugPrint('disconnect'));
  }

  disconnect() {
    socket.disconnect();
    //  socket.dispose();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
