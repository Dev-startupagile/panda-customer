
import 'dart:convert';

TechnicianProfileModel technicianProfileModelFromJson(String str) => TechnicianProfileModel.fromJson(json.decode(str));

String technicianProfileModelToJson(TechnicianProfileModel data) => json.encode(data.toJson());

class TechnicianProfileModel {
  TechnicianProfileModel({
    required this.success,
    required this.code,
    required this.data,
  });

  bool success;
  int code;
  Data data;

  factory TechnicianProfileModel.fromJson(Map<String, dynamic> json) => TechnicianProfileModel(
    success: json["success"],
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.phoneNumber,
    this.userRole,
    this.subscription,
    this.createdAt,
    this.fullName,
    this.state,
    this.city,
    this.isActive,
    this.userId,
    this.profilePicture,
    this.updatedAt,
    this.id,
    this.zipCode,
    this.street,
  });

  String? phoneNumber;
  String? userRole;
  String? subscription;
  DateTime? createdAt;
  String? fullName;
  String? state;
  String? city;
  bool? isActive;
  String? userId;
  String? profilePicture;
  DateTime? updatedAt;
  String? id;
  int? zipCode;
  String? street;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    phoneNumber: json["phoneNumber"],
    userRole: json["userRole"],
    subscription: json["subscription"],
    createdAt: DateTime.parse(json["createdAt"]),
    fullName: json["fullName"],
    state: json["state"],
    city: json["city"],
    isActive: json["isActive"],
    userId: json["userID"],
    profilePicture: json["profilePicture"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    id: json["id"],
    zipCode: json["zipCode"],
    street: json["street"],
  );

  Map<String, dynamic> toJson() => {
    "phoneNumber": phoneNumber,
    "userRole": userRole,
    "subscription": subscription,
    "createdAt": createdAt?.toIso8601String(),
    "fullName": fullName,
    "state": state,
    "city": city,
    "isActive": isActive,
    "userID": userId,
    "profilePicture": profilePicture,
    "updatedAt": updatedAt?.toIso8601String(),
    "id": id,
    "zipCode": zipCode,
    "street": street,
  };
}
