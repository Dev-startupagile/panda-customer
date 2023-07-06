// To parse this JSON data, do
//
//     final signInModel = signInModelFromJson(jsonString);

import 'dart:convert';

SignInModel signInModelFromJson(String str) => SignInModel.fromJson(json.decode(str));

String signInModelToJson(SignInModel data) => json.encode(data.toJson());

class SignInModel {
  SignInModel({
    this.success,
    this.token,
    this.message,
  });

  bool? success;
  String? token;
  String? message;

  factory SignInModel.fromJson(Map<String, dynamic> json) => SignInModel(
    success: json["success"],
    token: json["token"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "token": token,
    "message": message,
  };
}
