class PairingStatusModel {
  final String? role;
  final bool? isVerified;
final bool? isPinSet;
  PairingStatusModel({this.role, this.isVerified,this.isPinSet});

  factory PairingStatusModel.fromJson(Map<String, dynamic> json) {
    return PairingStatusModel(
      role: json['role'],
      isVerified: json["isVerified"] ?? false,
      isPinSet: json["isPinSet"]
    );
  }
}
