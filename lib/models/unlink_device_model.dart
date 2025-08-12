class UnlinkDeviceModel {
  final String? message;

  UnlinkDeviceModel({this.message});

  factory UnlinkDeviceModel.fromJson(Map<String, dynamic> json) {
    return UnlinkDeviceModel(message: json['message']);
  }
}
