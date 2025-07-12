import 'dart:developer';

class GetContentFilterModel {
  final String? sId;
  final String? childDeviceId;
  final int? iV;
  final bool? allowAutoplay;
  final bool? allowSearch;
  final bool? blockUnsafeVideos;
  final List<String>? blockedChannels;
  final List<String>? blockedCategories;
  final bool? isLocked;
  final int? screenTimeLimitMins;
  final String? updatedAt;

  GetContentFilterModel(
      {this.sId,
      this.childDeviceId,
      this.iV,
      this.allowAutoplay,
      this.allowSearch,
      this.blockUnsafeVideos,
      this.blockedChannels,
      this.isLocked,
      this.screenTimeLimitMins,
      this.updatedAt,
      this.blockedCategories});

  factory GetContentFilterModel.fromJson(Map<String, dynamic> json) {
    return GetContentFilterModel(
        sId: json['_id'],
        childDeviceId: json['childDeviceId'],
        iV: json['__v'],
        allowAutoplay: json['allowAutoplay'],
        allowSearch: json['allowSearch'],
        blockUnsafeVideos: json['blockUnsafeVideos'],
        blockedChannels: json['blockedChannels']?.cast<String>(),
        isLocked: json['isLocked'],
        screenTimeLimitMins: json['screenTimeLimitMins'],
        updatedAt: json['updatedAt'],
        blockedCategories: json["blockedCategories"]?.cast<String>());
  }
}
