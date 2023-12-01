import 'dart:convert';

NearByModel nearByModelFromJson(String str) =>
    NearByModel.fromJson(json.decode(str));

String nearByModelToJson(NearByModel data) => json.encode(data.toJson());

class NearByModel {
  NearByModel({
    required this.success,
    required this.code,
    required this.data,
  });

  bool success;
  int code;
  List<Datum> data;

  factory NearByModel.fromJson(Map<String, dynamic> json) => NearByModel(
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
    this.hourlyFee,
    this.diagnosticFee,
    this.isOnline,
    this.companyName,
    this.updatedAt,
    this.longitude,
    this.createdAt,
    this.id,
    this.latitude,
    this.distance,
    this.technicianDetail,
    this.fullName,
  });

  int? hourlyFee;
  int? diagnosticFee;
  bool? isOnline;
  String? companyName;
  DateTime? updatedAt;
  double? longitude;
  DateTime? createdAt;
  String? id;
  double? latitude;
  String? distance;
  TechnicianDetail? technicianDetail;
  String? fullName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        hourlyFee: json["hourlyFee"],
        diagnosticFee: json["diagnosticFee"],
        isOnline: json["isOnline"],
        companyName: json["companyName"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        longitude: json["longitude"].toDouble(),
        createdAt: DateTime.parse(json["createdAt"]),
        id: json["id"],
        latitude: json["latitude"].toDouble(),
        distance: json["distance"],
        technicianDetail: TechnicianDetail.fromJson(json["technicianDetail"]),
        fullName: json["fullName"],
      );

  Map<String, dynamic> toJson() => {
        "hourlyFee": hourlyFee,
        "diagnosticFee": diagnosticFee,
        "isOnline": isOnline,
        "companyName": companyName,
        "updatedAt": updatedAt?.toIso8601String(),
        "longitude": longitude,
        "createdAt": createdAt?.toIso8601String(),
        "id": id,
        "latitude": latitude,
        "distance": distance,
        "technicianDetail": technicianDetail?.toJson(),
        "fullName": fullName,
      };
}

class TechnicianDetail {
  TechnicianDetail(
      {this.phoneNumber,
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
      this.hourlyFee,
      this.diagnosticFee,
      this.isOnline,
      this.companyName,
      this.longitude,
      this.latitude,
      required this.rating,
      required this.reviewCount});

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
  int? hourlyFee;
  int? diagnosticFee;
  bool? isOnline;
  String? companyName;
  double? longitude;
  double? latitude;

  double rating;
  int reviewCount;

  factory TechnicianDetail.fromJson(Map<String, dynamic> json) =>
      TechnicianDetail(
        phoneNumber: json["phoneNumber"],
        userRole: json["userRole"],
        subscription: json["subscription"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        fullName: json["fullName"],
        state: json["state"],
        city: json["city"],
        isActive: json["isActive"],
        userId: json["userID"],
        profilePicture: json["profilePicture"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        id: json["id"],
        zipCode: json["zipCode"],
        street: json["street"],
        hourlyFee: json["hourlyFee"],
        diagnosticFee: json["diagnosticFee"],
        isOnline: json["isOnline"],
        companyName: json["companyName"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        rating: (json["rating"] ?? 0) / 1,
        reviewCount: json["reviewCount"] ?? 0,
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
        "hourlyFee": hourlyFee,
        "diagnosticFee": diagnosticFee,
        "isOnline": isOnline,
        "companyName": companyName,
        "longitude": longitude,
        "latitude": latitude,
        "rating": rating,
        "reviewCount": reviewCount,
      };
}
