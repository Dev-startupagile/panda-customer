import 'dart:convert';

import 'package:panda/models/tokenized_card.dart';

CustomerProfileModel customerProfileModelFromJson(String str) =>
    CustomerProfileModel.fromJson(json.decode(str));

String customerProfileModelToJson(CustomerProfileModel data) =>
    json.encode(data.toJson());

class CustomerProfileModel {
  CustomerProfileModel({
    required this.status,
    required this.data,
  });

  bool status;
  Data data;

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) =>
      CustomerProfileModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.personalInformation,
    required this.vehicles,
    required this.payments,
  });

  PersonalInformation personalInformation;
  Vehicles vehicles;
  Payments payments;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        personalInformation:
            PersonalInformation.fromJson(json["personalInformation"]),
        vehicles: Vehicles.fromJson(json["vehicles"]),
        payments: Payments.fromJson(json["payments"]),
      );

  Map<String, dynamic> toJson() => {
        "personalInformation": personalInformation.toJson(),
        "vehicles": vehicles.toJson(),
        "payments": payments.toJson(),
      };
}

class Payments {
  Payments({
    required this.code,
    required this.items,
    required this.count,
    required this.scannedCount,
  });

  int code;
  List<TokenizedCard> items;
  int count;
  int scannedCount;

  factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        code: json["code"],
        items: List<TokenizedCard>.from(
            json["Items"].map((x) => TokenizedCard.fromMap(x))),
        count: json["Count"],
        scannedCount: json["ScannedCount"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "Items": List<dynamic>.from(items.map((x) => x.toJson())),
        "Count": count,
        "ScannedCount": scannedCount,
      };
}

class PaymentsItem {
  PaymentsItem({
    this.isActive,
    this.expiryDate,
    this.image,
    this.updatedAt,
    this.createdAt,
    this.email,
    this.id,
    this.cvc,
    this.type,
  });

  bool? isActive;
  String? expiryDate;
  String? image;
  DateTime? updatedAt;
  DateTime? createdAt;
  String? email;
  String? id;
  String? cvc;
  String? type;

  factory PaymentsItem.fromJson(Map<String, dynamic> json) => PaymentsItem(
        isActive: json["isActive"],
        expiryDate: json["expiryDate"],
        image: json["image"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
        email: json["email"],
        id: json["id"],
        cvc: json["cvc"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "isActive": isActive,
        "expiryDate": expiryDate,
        "image": image,
        "updatedAt": updatedAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "email": email,
        "id": id,
        "cvc": cvc,
        "type": type,
      };
}

class PersonalInformation {
  PersonalInformation({
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

  factory PersonalInformation.fromJson(Map<String, dynamic> json) =>
      PersonalInformation(
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

class Vehicles {
  Vehicles({
    required this.code,
    required this.items,
    required this.count,
    required this.scannedCount,
  });

  int code;
  List<VehiclesItem> items;
  int count;
  int scannedCount;

  factory Vehicles.fromJson(Map<String, dynamic> json) => Vehicles(
        code: json["code"],
        items: List<VehiclesItem>.from(
            json["Items"].map((x) => VehiclesItem.fromJson(x))),
        count: json["Count"],
        scannedCount: json["ScannedCount"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "Items": List<dynamic>.from(items.map((x) => x.toJson())),
        "Count": count,
        "ScannedCount": scannedCount,
      };
}

class VehiclesItem {
  VehiclesItem({
    required this.model,
    required this.createdAt,
    required this.brand,
    required this.email,
    required this.make,
    required this.image,
    required this.updatedAt,
    this.isFavorite,
    required this.plateNumber,
    required this.description,
    required this.id,
    required this.color,
    required this.transmission,
  });

  String model;
  DateTime createdAt;
  String brand;
  String email;
  dynamic make;
  String image;
  DateTime updatedAt;
  bool? isFavorite;
  int plateNumber;
  String description;
  String id;
  String color;
  String transmission;

  factory VehiclesItem.fromJson(Map<String, dynamic> json) => VehiclesItem(
        model: json["model"],
        createdAt: DateTime.parse(json["createdAt"]),
        brand: json["brand"],
        email: json["email"],
        make: json["make"],
        image: json["image"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        isFavorite: json["isFavorite"],
        plateNumber: json["plateNumber"],
        description: json["description"],
        id: json["id"],
        color: json["color"],
        transmission: json["transmission"],
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "createdAt": createdAt.toIso8601String(),
        "brand": brand,
        "email": email,
        "make": make,
        "image": image,
        "updatedAt": updatedAt.toIso8601String(),
        "isFavorite": isFavorite,
        "plateNumber": plateNumber,
        "description": description,
        "id": id,
        "color": color,
        "transmission": transmission,
      };
}
