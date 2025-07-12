class SendKidsActivitiesModel {
  final String? message;
  final Log? log;

  SendKidsActivitiesModel({this.message, this.log});

  factory SendKidsActivitiesModel.fromJson(Map<String, dynamic> json) {
    return SendKidsActivitiesModel(
      message: json['message'],
      log: json['log'] != null ? Log.fromJson(json['log']) : null,
    );
  }
}

class Log {
  final String? childDeviceId;
  final String? videoId;
  final String? title;
  final String? channelName;
  final String? thumbnail;
  final int? duration;
  final String? sId;
  final String? watchedAt;
  final int? iV;

  Log(
      {this.childDeviceId,
      this.videoId,
      this.title,
      this.channelName,
      this.thumbnail,
      this.duration,
      this.sId,
      this.watchedAt,
      this.iV});

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
        childDeviceId: json['childDeviceId'],
        videoId: json['videoId'],
        title: json['title'],
        channelName: json['channelName'],
        thumbnail: json['thumbnail'],
        duration: json['duration'],
        sId: json['_id'],
        watchedAt: json['watchedAt'],
        iV: json['__v']);
  }
}
