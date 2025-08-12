class SetPinModel {
  String? message;

  SetPinModel({this.message});

  factory SetPinModel.fromJson(Map<String, dynamic> json) {
    return SetPinModel(message: json['message']);
  }
}
