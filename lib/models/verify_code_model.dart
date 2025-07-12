class VerifyCodeModel {
  final String? message;

  VerifyCodeModel({this.message});

  factory VerifyCodeModel.fromJson(Map<String, dynamic> json) {
    return VerifyCodeModel(message: json['message']);
  }
}
