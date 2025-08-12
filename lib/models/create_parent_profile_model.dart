class CreateParentProfileModel {
  final String? message;
  final Profile? profile;

  const CreateParentProfileModel({
    required this.message,
    required this.profile,
  });

  factory CreateParentProfileModel.fromJson(Map<String, dynamic> json) {
    return CreateParentProfileModel(
      message: json['message'] ?? '',
      profile: Profile.fromJson(json['profile'] ?? {}),
    );
  }
}

class Profile {
  final String? parentDeviceId;
  final String? name;
  final String? phone;
  final String? email;
  final String? kidName;
  final String? trialStartedAt;
  final String? trialExpiresAt;
  final bool? isTrialExpired;
  final String? sId;
  final String? createdAt;
  final String? updatedAt;
  final int? iV;

  const Profile({
    required this.parentDeviceId,
    required this.name,
    required this.phone,
    required this.email,
    required this.kidName,
    required this.trialStartedAt,
    required this.trialExpiresAt,
    required this.isTrialExpired,
    required this.sId,
    required this.createdAt,
    required this.updatedAt,
    required this.iV,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      parentDeviceId: json['parentDeviceId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      kidName: json['kidName'] ?? '',
      trialStartedAt: json['trialStartedAt'] ?? '',
      trialExpiresAt: json['trialExpiresAt'] ?? '',
      isTrialExpired: json['isTrialExpired'] ?? false,
      sId: json['_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      iV: json['__v'] ?? 0,
    );
  }
}
