class GenerateCodeModel {
  String? code;

  GenerateCodeModel({this.code});

  factory GenerateCodeModel.fromJson(Map<String, dynamic> json) {
    return GenerateCodeModel(code: json['code']);
  }
}
