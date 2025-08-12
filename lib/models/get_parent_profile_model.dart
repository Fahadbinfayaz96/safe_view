class GetParentProfileModel {
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
  final String? subscriptionExpiresAt;
  final List<SubscriptionHistory>? subscriptionHistory;
  final bool? subscriptionOver;
  final bool? subscriptionStarted;
  final String? childDeviceId;
  final String? message;

  GetParentProfileModel({
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
    this.isSubscribed,
    this.subscriptionExpiresAt,
    this.subscriptionHistory,
    this.subscriptionOver,
    this.subscriptionStarted,
    this.childDeviceId,
    this.message,
  });

  factory GetParentProfileModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('message') && !json.containsKey('profile')) {
      return GetParentProfileModel(message: json['message']);
    }

    final profileData = json['profile'] ?? json;

    return GetParentProfileModel(
      sId: profileData['_id'],
      parentDeviceId: profileData['parentDeviceId'],
      name: profileData['name'],
      phone: profileData['phone'],
      email: profileData['email'],
      kidName: profileData['kidName'],
      trialStartedAt: profileData['trialStartedAt'],
      trialExpiresAt: profileData['trialExpiresAt'],
      isTrialExpired: profileData['isTrialExpired'],
      createdAt: profileData['createdAt'],
      updatedAt: profileData['updatedAt'],
      iV: profileData['__v'],
      isSubscribed: profileData['isSubscribed'],
      subscriptionExpiresAt: profileData['subscriptionExpiresAt'],
      subscriptionHistory: (profileData['subscriptionHistory'] as List?)
          ?.map((e) => SubscriptionHistory.fromJson(e))
          .toList(),
      subscriptionOver: profileData['subscriptionOver'],
      subscriptionStarted: profileData['subscriptionStarted'],
      childDeviceId: profileData['childDeviceId'],
      message: json['message'] ?? '',
    );
  }
}

class SubscriptionHistory {
  final String? subscribedAt;
  final String? expiresAt;
  final int? durationDays;
  final String? id;

  SubscriptionHistory({
    this.subscribedAt,
    this.expiresAt,
    this.durationDays,
    this.id,
  });

  factory SubscriptionHistory.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistory(
      subscribedAt: json['subscribedAt'],
      expiresAt: json['expiresAt'],
      durationDays: json['durationDays'],
      id: json['_id'],
    );
  }
}
