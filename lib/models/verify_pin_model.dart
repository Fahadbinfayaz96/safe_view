class VerifyPinModel {
  String? message;

  VerifyPinModel({this.message});

  factory VerifyPinModel.fromJson(Map<String, dynamic> json) {
    return VerifyPinModel(message: json['message']);
  }
}
