class TrackTimeLimitModel {
  final String? message;
  final int? totalWatchedToday;
  final int? remainingTime;
  final bool? limitReached;

  const TrackTimeLimitModel({
    this.message,
    this.totalWatchedToday,
    this.remainingTime,
    this.limitReached,
  });

  factory TrackTimeLimitModel.fromJson(Map<String, dynamic> json) {
    return TrackTimeLimitModel(
      message: json['message'],
      totalWatchedToday: json['totalWatchedToday'],
      remainingTime: json['remainingTime'],
      limitReached: json['limitReached'],
    );
  }

 
}
