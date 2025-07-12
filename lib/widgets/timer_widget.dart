import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ScreenTimeLimitListener extends StatefulWidget {
  const ScreenTimeLimitListener({super.key});

  @override
  State<ScreenTimeLimitListener> createState() =>
      _ScreenTimeLimitListenerState();
}

class _ScreenTimeLimitListenerState extends State<ScreenTimeLimitListener> {
  late IO.Socket socket;
  String status = "Connecting...";
  final String childDeviceId = "abc123-child-device-i29";

  @override
  void initState() {
    log("initState");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSocket();
    });
  }

  void _initializeSocket() {
    log("_initializeSocket");
    socket = IO.io(
      'https://safeview-backend.onrender.com', // ⚠️ Replace with your backend IP if not running locally
      IO.OptionBuilder()
          .setTransports(['websocket']) // required
          .disableAutoConnect() // optional
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      log("✅ Connected to server");
      setState(() {
        status = "✅ Connected to server";
      });
      socket.emit("join", childDeviceId);
    });

    socket.on("limitReached", (data) {
      log("⏰ Limit Reached: ${data['message']}");
      setState(() {
        status = "⛔ Limit Reached!";
      });
      _showLimitDialog(data['message']);
    });

    socket.onDisconnect((_) {
      log("🔌 Disconnected from server");
      setState(() {
        status = "❌ Disconnected";
      });
    });

    socket.onConnectError((err) {
      log("⚠️ Connection Error: $err");
    });
  }

  void _showLimitDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("⏰ Time Limit Reached"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🧒 Screen Time Limit Listener")),
      body: Center(child: Text(status, style: const TextStyle(fontSize: 20))),
    );
  }
}
