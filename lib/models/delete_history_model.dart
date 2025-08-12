class DeleteHistoryModel {
  final String? message;

  DeleteHistoryModel({this.message});

  factory DeleteHistoryModel.fromJson(Map<String, dynamic> json) {
    return DeleteHistoryModel(message: json['message']);
  }
}
