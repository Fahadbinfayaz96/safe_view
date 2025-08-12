class TrailStatusModel {
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
  final bool? isSubscribed;
  const TrailStatusModel({
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
    this.isSubscribed
  });

  factory TrailStatusModel.fromJson(Map<String, dynamic> json) {
    return TrailStatusModel(
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
      isSubscribed: json['isSubscribed']
    );
  }
}
