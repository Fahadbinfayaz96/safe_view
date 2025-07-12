class UpdateContentFilterModel {
  final String? message;
  final Settings? settings;

  UpdateContentFilterModel({this.message, this.settings});

  factory UpdateContentFilterModel.fromJson(Map<String, dynamic> json) {
    return UpdateContentFilterModel(
      message: json['message'],
      settings: json['settings'] != null 
          ? Settings.fromJson(json['settings']) 
          : null,
    );
  }
}

class Settings {
  final String? sId;
  final String? childDeviceId;
  final int? iV;
  final bool? allowAutoplay;
  final bool? allowSearch;
  final List<String>? blockedChannels;
  final String? updatedAt;
  final bool? blockUnsafeVideos;
  final bool? isLocked;
  final int? screenTimeLimitMins;

  Settings({
    this.sId,
    this.childDeviceId,
    this.iV,
    this.allowAutoplay,
    this.allowSearch,
    this.blockedChannels,
    this.updatedAt,
    this.blockUnsafeVideos,
    this.isLocked,
    this.screenTimeLimitMins,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      sId: json['_id'],
      childDeviceId: json['childDeviceId'],
      iV: json['__v'],
      allowAutoplay: json['allowAutoplay'],
      allowSearch: json['allowSearch'],
      blockedChannels: json['blockedChannels']?.cast<String>(),
      updatedAt: json['updatedAt'],
      blockUnsafeVideos: json['blockUnsafeVideos'],
      isLocked: json['isLocked'],
      screenTimeLimitMins: json['screenTimeLimitMins'],
    );
  }
}