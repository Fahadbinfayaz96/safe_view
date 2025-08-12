class EditParentProfileModel {
  final String? message;
  final Profile? profile;

  const EditParentProfileModel({
    this.message,
    this.profile,
  });

  factory EditParentProfileModel.fromJson(Map<String, dynamic> json) {
    return EditParentProfileModel(
      message: json['message'] as String?,
      profile: json['profile'] != null
          ? Profile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Profile {
  final String? sId;
  final String? parentDeviceId;
  final String? name;
  final String? phone;
  final String? email;
  final String? kidName;
  final String? trialStartedAt;
  final String? trialExpiresAt;
  final bool? isTrialExpired;
  final String? createdAt;
  final String? updatedAt;
  final int? iV;

  const Profile({
    this.sId,
    this.parentDeviceId,
    this.name,
    this.phone,
    this.email,
    this.kidName,
    this.trialStartedAt,
    this.trialExpiresAt,
    this.isTrialExpired,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      sId: json['_id'] as String?,
      parentDeviceId: json['parentDeviceId'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      kidName: json['kidName'] as String?,
      trialStartedAt: json['trialStartedAt'] as String?,
      trialExpiresAt: json['trialExpiresAt'] as String?,
      isTrialExpired: json['isTrialExpired'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: json['__v'] as int?,
    );
  }
}
