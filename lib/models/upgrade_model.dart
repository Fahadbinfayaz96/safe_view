class UpgradeModel {
  final String? message;
  final Interest? interest;

  UpgradeModel({this.message, this.interest});

  factory UpgradeModel.fromJson(Map<String, dynamic> json) => UpgradeModel(
        message: json['message'],
        interest: json['interest'] != null
            ? Interest.fromJson(json['interest'])
            : null,
      );
}

class Interest {
  final String? parentDeviceId;
  final String? name;
  final String? phone;
  final String? email;
  final String? kidName;
  final bool? isInterested;
  final String? message;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  Interest({
    this.parentDeviceId,
    this.name,
    this.phone,
    this.email,
    this.kidName,
    this.isInterested,
    this.message,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
        parentDeviceId: json['parentDeviceId'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        kidName: json['kidName'],
        isInterested: json['isInterested'],
        message: json['message'],
        id: json['_id'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        v: json['__v'],
      );
}
