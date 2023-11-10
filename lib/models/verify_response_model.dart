// To parse this JSON data, do
//
//     final verifyResponseModel = verifyResponseModelFromJson(jsonString);

import 'dart:convert';

VerifyResponseModel verifyResponseModelFromJson(String str) => VerifyResponseModel.fromJson(json.decode(str));

String verifyResponseModelToJson(VerifyResponseModel data) => json.encode(data.toJson());

class VerifyResponseModel {
  VerifyResponseModel({
    required this.success,
    required this.message,
    required this.token,
  });

  bool success;
  String message;
  String token;

  factory VerifyResponseModel.fromJson(Map<String, dynamic> json) => VerifyResponseModel(
    success: json["success"],
    message: json["message"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "token": token,
  };
}
