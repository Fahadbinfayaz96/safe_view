class GetRemainingTimeModel {
  final int? dailyLimitMins;
  final int? totalWatchedMins;
  final int? remainingTimeMins;
  final bool? limitReached;
  
  const GetRemainingTimeModel({
    this.dailyLimitMins,
    this.totalWatchedMins,
    this.remainingTimeMins,
    this.limitReached,
  });

  factory GetRemainingTimeModel.fromJson(Map<String, dynamic> json) {
    return GetRemainingTimeModel(
      dailyLimitMins: json['dailyLimitMins'],
      totalWatchedMins: json['totalWatchedMins'],
      remainingTimeMins: json['remainingTimeMins'],
      limitReached: json['limitReached'],
    );
  }


}
