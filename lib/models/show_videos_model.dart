class ShowVideosModel {
  final bool? isLocked;
  final int? page;
  final int? limit;
  final int? totalResults;
  final List<Videos>? videos;
  final String? message; // 👈 for handling error responses

  ShowVideosModel({
    this.isLocked,
    this.page,
    this.limit,
    this.totalResults,
    this.videos,
    this.message,
  });

  factory ShowVideosModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('message') && json.length == 1) {
      return ShowVideosModel(message: json['message']);
    }

    return ShowVideosModel(
      isLocked: json['isLocked'] ?? false,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalResults: json['totalResults'] ?? 0,
      videos: (json['videos'] as List<dynamic>? ?? [])
          .map((x) => Videos.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }
}


class Videos {
  final String? videoId;
  final String? title;
  final String? description;
  final String? thumbnail;
  final String? channel;
  final String? categoryId;

  Videos({
    this.videoId,
    this.title,
    this.description,
    this.thumbnail,
    this.channel,
    this.categoryId,
  });

  factory Videos.fromJson(Map<String, dynamic> json) {
    return Videos(
      videoId: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      channel: json['channelTitle'] ?? '',
      categoryId: json['categoryId'] ?? '',
    );
  }
}
