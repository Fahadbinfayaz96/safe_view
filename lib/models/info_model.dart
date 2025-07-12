class InfoModel {
  final String? deviceId;
  final String? role;
  final String? pairedWith;

  InfoModel({this.deviceId, this.role, this.pairedWith});

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      deviceId: json['deviceId'],
      role: json['role'],
      pairedWith: json['pairedWith'],
    );
  }
}
