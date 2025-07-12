// screen_time_cubit.dart
import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'usage_timer_state.dart';

class ScreenTimeCubit extends Cubit<ScreenTimeState> {
  final String childDeviceId;
  final int initialLimitInMinutes;

  late IO.Socket socket;
  Timer? localTimer;

  ScreenTimeCubit({
    required this.childDeviceId,
    required this.initialLimitInMinutes,
  }) : super(const ScreenTimeState()) {
    initializeSocket();
  }

  void initializeSocket() {
    log("_initializeSocket");
    socket = IO.io(
      'https://safeview-backend.onrender.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      log("✅ Connected to server");
      socket.emit("join", childDeviceId);

      emit(state.copyWith(
        status: "✅ Connected",
        remainingSeconds: initialLimitInMinutes * 60,
      ));
      startLocalTimer();
    });

    socket.on("limitReached", (data) {
      log("⏰ Limit Reached: ${data['message']}");
      stopLocalTimer();
      emit(state.copyWith(isLimitReached: true, status: "⛔ Limit Reached!"));
    });

    socket.onDisconnect((_) {
      log("🔌 Disconnected from server");
      emit(state.copyWith(status: "❌ Disconnected"));
    });

    socket.onConnectError((err) {
      log("⚠️ Connection Error: $err");
      emit(state.copyWith(status: "⚠️ Connection Error"));
    });
  }

  void startLocalTimer() {
    stopLocalTimer();
    localTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final secs = state.remainingSeconds;
      if (secs == null || state.isLimitReached) return;

      if (secs <= 1) {
        socket.emit("timeExpired", childDeviceId);
        stopLocalTimer();
        emit(state.copyWith(remainingSeconds: 0, isLimitReached: true));
      } else {
        emit(state.copyWith(remainingSeconds: secs - 1));
      }
    });
  }

  void stopLocalTimer() {
    localTimer?.cancel();
  }

  void resumeTimerFromAppLifecycle() {
    if (!state.isLimitReached && state.remainingSeconds != null) {
      startLocalTimer();
    }
  }

  void pauseTimerFromAppLifecycle() {
    stopLocalTimer();
  }

  @override
  Future<void> close() {
    stopLocalTimer();
    socket.dispose();
    return super.close();
  }
}
