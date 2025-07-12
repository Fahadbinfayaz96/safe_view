import 'package:equatable/equatable.dart';

class ScreenTimeState extends Equatable {
  final int? remainingSeconds;
  final bool isLimitReached;
  final String status;

  const ScreenTimeState({
    this.remainingSeconds,
    this.isLimitReached = false,
    this.status = "Connecting...",
  });

  ScreenTimeState copyWith({
    int? remainingSeconds,
    bool? isLimitReached,
    String? status,
  }) {
    return ScreenTimeState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isLimitReached: isLimitReached ?? this.isLimitReached,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [remainingSeconds, isLimitReached, status];
}
