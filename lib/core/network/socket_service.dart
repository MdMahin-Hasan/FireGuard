import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constant/api_constants.dart';

/// One shared Socket.io connection for the whole app.
///
/// Server events (see API docs section 9):
///   sensor:reading   - a new sensor reading was received
///   alert:new        - a new alert was created
///   alert:verified   - an alert was confirmed / marked false_alarm
///   alert:resolved   - an alert was resolved
///   alert:notified   - a fire station was notified
class SocketService {
  SocketService._();

  static final SocketService instance = SocketService._();

  IO.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  /// Connects once. Safe to call multiple times (e.g. from several
  /// controllers' onInit) - subsequent calls are a no-op if already
  /// connected/connecting.
  void connect() {
    if (_socket != null) return;

    _socket = IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .build(),
    );
  }

  void onConnect(void Function() callback) =>
      _socket?.onConnect((_) => callback());

  void onDisconnect(void Function() callback) =>
      _socket?.onDisconnect((_) => callback());

  void on(String event, void Function(dynamic data) callback) =>
      _socket?.on(event, callback);

  /// Remove one listener for [event]. Call this from a controller's
  /// onClose with the SAME function reference passed to `on`, so the
  /// screen's callback doesn't keep firing after it's gone.
  void off(String event, [void Function(dynamic data)? callback]) =>
      _socket?.off(event, callback);

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }
}