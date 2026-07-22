import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  factory WebSocketManager() => _instance;

  WebSocketManager._internal();

  IOWebSocketChannel? _channel;
  StreamSubscription? _subscription;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  final StreamController<dynamic> _controller =
  StreamController<dynamic>.broadcast();

  Stream<dynamic> get stream => _controller.stream;

  /// 🔗 Connect
  Future<void> connect(String url) async {
    try {
      debugPrint("🔌 Connecting to WebSocket...");

      _channel = IOWebSocketChannel.connect(url);

      _subscription = _channel!.stream.listen(
            (message) {
          debugPrint("📩 Message: $message");

          try {
            final decoded = jsonDecode(message);
            _controller.add(decoded);

            /// 👉 Handle Pusher events
            _handlePusherEvent(decoded);
          } catch (e) {
            _controller.add(message);
          }
        },
        onDone: () {
          debugPrint("❌ Socket closed");
          _isConnected = false;
          _reconnect(url);
        },
        onError: (error) {
          debugPrint("⚠️ Error: $error");
          _isConnected = false;
          _reconnect(url);
        },
      );

      _isConnected = true;
      debugPrint("✅ Connected");
    } catch (e) {
      debugPrint("❌ Connection failed: $e");
      _reconnect(url);
    }
  }

  /// 🔁 Auto Reconnect
  void _reconnect(String url) {
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isConnected) {
        debugPrint("🔄 Reconnecting...");
        connect(url);
      }
    });
  }

  /// 📤 Send message
  void send(dynamic data) {
    if (_channel != null && _isConnected) {
      final message = jsonEncode(data);
      debugPrint("📤 Sending: $message");
      _channel!.sink.add(message);
    } else {
      debugPrint("⚠️ Cannot send, socket not connected");
    }
  }

  /// ❌ Disconnect
  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close(status.goingAway);
    _isConnected = false;
    debugPrint("🔌 Disconnected");
  }

  /// 🔥 Pusher Subscribe Example
  void subscribe(String channelName) {
    final data = {
      "event": "pusher:subscribe",
      "data": {"channel": channelName},
    };

    send(data);
  }

  /// 💡 Handle Pusher Events
  void _handlePusherEvent(dynamic data) {
    final event = data['event'];

    /// ✅ Connection established
    if (event == 'pusher:connection_established') {
      debugPrint("🎉 Pusher Connected");

      /// 👉 Auto subscribe here
      subscribe("delivery-orders");
    }

    /// ✅ Subscription success
    if (event == 'pusher_internal:subscription_succeeded') {
      final channel = data['channel'];
      debugPrint("✅ Subscribed: $channel");
    }

    /// ✅ Delivery Orders event on delivery-orders channel
    final channelName = data['channel'];
    if (channelName == 'delivery-orders' ||
        event == 'delivery-orders' ||
        event == 'order.created' ||
        event == 'order.updated') {
      try {
        final rawData = data['data'];
        final parsedData = rawData is String ? jsonDecode(rawData) : rawData;
        debugPrint("📦 Delivery Orders Event Received: $event");
        _controller.add({"type": "delivery_orders_updated", "channel": "delivery-orders", "data": parsedData});
      } catch (e) {
        debugPrint("❌ Error parsing delivery-orders event: $e");
        _controller.add({"type": "delivery_orders_updated", "channel": "delivery-orders"});
      }
    }

    /// 👉 Demo: handle ping (optional)
    if (event == 'pusher:ping') {
      debugPrint("🏓 Ping received → sending pong");

      send({"event": "pusher:pong", "data": {}});
    }
  }
}
