import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  // Connect to the WebSocket server
  void connect() {
    socket = IO.io('http://192.168.56.1:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('Connected to WebSocket');
    });

    socket.onDisconnect((_) {
      print('Disconnected from WebSocket');
    });
  }

  // Method to listen to events
  void on(String event, Function(dynamic) callback) {
    socket.on(
        event, callback); // Attach listener regardless of connection state
    print('Listener attached for $event');
  }

  // Disconnect the WebSocket
  void disconnect() {
    socket.disconnect();
  }
}
