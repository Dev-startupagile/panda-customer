// To parse this JSON data, do
//
//     final serviceModel = serviceModelFromJson(jsonString);

import 'dart:convert';

ServiceModel serviceModelFromJson(String str) => ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel {
  ServiceModel({
    required this.success,
    required this.code,
    required this.data,
  });

  bool success;
  int code;
  List<Datum> data;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    success: json["success"],
    code: json["code"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.createdAt,
    required this.description,
    required this.id,
    required this.updatedAt,
    required this.title,
  });

  DateTime createdAt;
  String description;
  String id;
  DateTime updatedAt;
  String title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    createdAt: DateTime.parse(json["createdAt"]),
    description: json["description"],
    id: json["id"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
    "description": description,
    "id": id,
    "updatedAt": updatedAt.toIso8601String(),
    "title": title,
  };
}