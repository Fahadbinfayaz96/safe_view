class PairingStatusModel {
  final String? role;
  final bool? isVerified;

  PairingStatusModel({this.role, this.isVerified});

  factory PairingStatusModel.fromJson(Map<String, dynamic> json) {
    return PairingStatusModel(
      role: json['role'],
      isVerified: json["isVerified"] ?? false,
    );
  }
}
