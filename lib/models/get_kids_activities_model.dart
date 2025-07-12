class GetKidsActivitiesModel {
  final String? sId;
  final String? childDeviceId;
  final String? videoId;
  final String? title;
  final String? channelName;
  final String? thumbnail;
  final int? duration;
  final String? watchedAt;
  final int? iV;

  GetKidsActivitiesModel(
      {this.sId,
      this.childDeviceId,
      this.videoId,
      this.title,
      this.channelName,
      this.thumbnail,
      this.duration,
      this.watchedAt,
      this.iV});

  factory GetKidsActivitiesModel.fromJson(Map<String, dynamic> json) {
    return GetKidsActivitiesModel(
      sId: json['_id'],
      childDeviceId: json['childDeviceId'],
      videoId: json['videoId'],
      title: json['title'],
      channelName: json['channelName'],
      thumbnail: json['thumbnail'],
      duration: json['duration'],
      watchedAt: json['watchedAt'],
      iV: json['__v'],
    );
  }
}
