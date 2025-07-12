class ShowVideosModel {
  final List<Videos>? videos;

  ShowVideosModel({this.videos});

  factory ShowVideosModel.fromJson(Map<String, dynamic> json) {
    return ShowVideosModel(
      videos: json['videos'] != null
          ? List<Videos>.from(json['videos'].map((x) => Videos.fromJson(x)))
          : null,
    );
  }
}

class Videos {
  final String? videoId;
  final String? title;
  final String? thumbnail;
  final String? channel;

  Videos({this.videoId, this.title, this.thumbnail, this.channel});

  factory Videos.fromJson(Map<String, dynamic> json) {
    return Videos(
      videoId: json['videoId'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      channel: json['channel'],
    );
  }
}