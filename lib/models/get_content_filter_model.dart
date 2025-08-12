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
  Map<String, dynamic> toJson() => {
        'blockUnsafeVideos': blockUnsafeVideos,
        'allowSearch': allowSearch,
        'allowAutoplay': allowAutoplay,
        'isLocked': isLocked,
        'blockedCategories': blockedCategories,
        'screenTimeLimitMins': screenTimeLimitMins,
      };

  bool isEqualTo(GetContentFilterModel other) {
    return isLocked == other.isLocked &&
        allowSearch == other.allowSearch &&
        allowAutoplay == other.allowAutoplay &&
        blockUnsafeVideos == other.blockUnsafeVideos &&
        screenTimeLimitMins == other.screenTimeLimitMins &&
        (blockedCategories == null
            ? other.blockedCategories == null
            : other.blockedCategories != null &&
                blockedCategories!.length == other.blockedCategories!.length &&
                blockedCategories!
                    .toSet()
                    .containsAll(other.blockedCategories!) &&
                other.blockedCategories!
                    .toSet()
                    .containsAll(blockedCategories!));
  }

  GetContentFilterModel copyWith({
    String? sId,
    String? childDeviceId,
    int? iV,
    bool? allowAutoplay,
    bool? allowSearch,
    bool? blockUnsafeVideos,
    List<String>? blockedChannels,
    List<String>? blockedCategories,
    bool? isLocked,
    int? screenTimeLimitMins,
    String? updatedAt,
  }) {
    return GetContentFilterModel(
      sId: sId ?? this.sId,
      childDeviceId: childDeviceId ?? this.childDeviceId,
      iV: iV ?? this.iV,
      allowAutoplay: allowAutoplay ?? this.allowAutoplay,
      allowSearch: allowSearch ?? this.allowSearch,
      blockUnsafeVideos: blockUnsafeVideos ?? this.blockUnsafeVideos,
      blockedChannels: blockedChannels ?? this.blockedChannels,
      blockedCategories: blockedCategories ?? this.blockedCategories,
      isLocked: isLocked ?? this.isLocked,
      screenTimeLimitMins: screenTimeLimitMins ?? this.screenTimeLimitMins,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
