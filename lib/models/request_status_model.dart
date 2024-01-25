// To parse this JSON data, do
//
//     final requestStatusModel = requestStatusModelFromJson(jsonString);

import 'dart:convert';

RequestStatusModel requestStatusModelFromJson(String str) =>
    RequestStatusModel.fromJson(json.decode(str));

String requestStatusModelToJson(RequestStatusModel data) =>
    json.encode(data.toJson());

class RequestStatusModel {
  RequestStatusModel({
    required this.success,
    required this.code,
    required this.count,
    required this.scannedCount,
    required this.data,
  });

  bool success;
  int code;
  int count;
  int scannedCount;
  List<Datum> data;

  factory RequestStatusModel.fromJson(Map<String, dynamic> json) =>
      RequestStatusModel(
        success: json["success"],
        code: json["code"],
        count: json["Count"],
        scannedCount: json["ScannedCount"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "Count": count,
        "ScannedCount": scannedCount,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.vehicleId,
    this.technicianId,
    this.createdAt,
    this.schedule,
    this.serviceLocation,
    this.updatedAt,
    this.serviceId,
    this.description,
    this.isDiagnosed,
    this.isScheduled,
    this.price,
    this.id,
    this.requestStatus,
    this.customerId,
    required this.vehiclesDetail,
    this.serviceDetail,
    this.technicianInfo,
    this.customerInfo,
  });

  List<String> vehicleId;
  String? technicianId;
  DateTime? createdAt;
  Schedule? schedule;
  ServiceLocation? serviceLocation;
  DateTime? updatedAt;
  String? serviceId;
  Description? description;
  bool? isDiagnosed;
  bool? isScheduled;
  Price? price;
  String? id;
  String? requestStatus;
  String? customerId;
  List<VehiclesDetail> vehiclesDetail;
  ServiceDetail? serviceDetail;
  TechnicianInfo? technicianInfo;
  CustomerInfo? customerInfo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        vehicleId: List<String>.from(json["vehicleId"].map((x) => x)),
        technicianId: json["technicianId"],
        createdAt: DateTime.parse(json["createdAt"]),
        schedule: Schedule.fromJson(json["schedule"]),
        serviceLocation: ServiceLocation.fromJson(json["serviceLocation"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        serviceId: json["serviceId"],
        description: Description.fromJson(json["description"]),
        isDiagnosed: json["isDiagnosed"],
        isScheduled: json["isScheduled"],
        price: Price.fromJson(json["price"]),
        id: json["id"],
        requestStatus: json["requestStatus"],
        customerId: json["customerId"],
        vehiclesDetail: json["vehiclesDetail"] == null
            ? []
            : List<VehiclesDetail>.from(json["vehiclesDetail"]
                .where((x) => x != null)
                .map((x) => VehiclesDetail.fromJson(x))),
        serviceDetail: ServiceDetail.fromJson(json["serviceDetail"]),
        technicianInfo: json["technicianInfo"] == null
            ? null
            : TechnicianInfo.fromJson(json["technicianInfo"]),
        customerInfo: json["customerInfo"] == null
            ? null
            : CustomerInfo.fromJson(json["customerInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "vehicleId": List<dynamic>.from(vehicleId.map((x) => x)),
        "technicianId": technicianId,
        "createdAt": createdAt?.toIso8601String(),
        "schedule": schedule?.toJson(),
        "serviceLocation": serviceLocation?.toJson(),
        "updatedAt": updatedAt?.toIso8601String(),
        "serviceId": serviceId,
        "description": description?.toJson(),
        "isDiagnosed": isDiagnosed,
        "isScheduled": isScheduled,
        "price": price?.toJson(),
        "id": id,
        "requestStatus": requestStatus,
        "customerId": customerId,
        "vehiclesDetail":
            List<dynamic>.from(vehiclesDetail.map((x) => x.toJson())),
        "serviceDetail": serviceDetail?.toJson(),
        "technicianInfo":
            technicianInfo == null ? null : technicianInfo?.toJson(),
        "customerInfo": customerInfo == null ? null : customerInfo?.toJson(),
      };
}

class CustomerInfo {
  CustomerInfo({
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

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => CustomerInfo(
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

class Description {
  Description({
    this.note,
    required this.attachments,
    this.title,
  });

  String? note;
  List<String> attachments;
  String? title;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        note: json["note"],
        attachments: List<String>.from(json["attachments"].map((x) => x)),
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "note": note,
        "attachments": List<dynamic>.from(attachments.map((x) => x)),
        "title": title == null ? null : title,
      };
}

class Price {
  Price({
    required this.diagnosticFee,
    required this.hourlyFee,
  });

  int diagnosticFee;
  int hourlyFee;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        diagnosticFee: json["diagnosticFee"],
        hourlyFee: json["hourlyFee"],
      );

  Map<String, dynamic> toJson() => {
        "diagnosticFee": diagnosticFee,
        "hourlyFee": hourlyFee,
      };
}

class Schedule {
  Schedule({
    required this.date,
    required this.time,
  });

  DateTime date;
  DateTime time;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        date: DateTime.parse(json["date"]),
        time: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "time": time.toIso8601String(),
      };
}

class ServiceDetail {
  ServiceDetail({
    this.createdAt,
    this.description,
    this.id,
    this.updatedAt,
    this.title,
  });

  DateTime? createdAt;
  String? description;
  String? id;
  DateTime? updatedAt;
  String? title;

  factory ServiceDetail.fromJson(Map<String, dynamic> json) => ServiceDetail(
        createdAt: DateTime.parse(json["createdAt"]),
        description: json["description"],
        id: json["id"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt?.toIso8601String(),
        "description": description,
        "id": id,
        "updatedAt": updatedAt?.toIso8601String(),
        "title": title,
      };
}

class ServiceLocation {
  ServiceLocation({required this.longitude, required this.latitude, this.name});

  double longitude;
  double latitude;
  String? name;

  factory ServiceLocation.fromJson(Map<String, dynamic> json) =>
      ServiceLocation(
        longitude: json["longitude"].toDouble(),
        latitude: json["latitude"].toDouble(),
        name: json["name"],
      );

  Map<String, dynamic> toJson() =>
      {"longitude": longitude, "latitude": latitude, "name": name};
}

class TechnicianInfo {
  TechnicianInfo({
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
    this.hourlyFee,
    this.diagnosticFee,
    this.isOnline,
    this.companyName,
    this.longitude,
    this.latitude,
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
  int? hourlyFee;
  int? diagnosticFee;
  bool? isOnline;
  String? companyName;
  double? longitude;
  double? latitude;

  factory TechnicianInfo.fromJson(Map<String, dynamic> json) => TechnicianInfo(
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        userRole: json["userRole"] == null ? null : json["userRole"],
        subscription:
            json["subscription"] == null ? null : json["subscription"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        fullName: json["fullName"] == null ? null : json["fullName"],
        state: json["state"] == null ? null : json["state"],
        city: json["city"] == null ? null : json["city"],
        isActive: json["isActive"] == null ? null : json["isActive"],
        userId: json["userID"] == null ? null : json["userID"],
        profilePicture:
            json["profilePicture"] == null ? null : json["profilePicture"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        id: json["id"] == null ? null : json["id"],
        zipCode: json["zipCode"] == null ? null : json["zipCode"],
        street: json["street"] == null ? null : json["street"],
        hourlyFee: json["hourlyFee"] == null ? null : json["hourlyFee"],
        diagnosticFee:
            json["diagnosticFee"] == null ? null : json["diagnosticFee"],
        isOnline: json["isOnline"] == null ? null : json["isOnline"],
        companyName: json["companyName"] == null ? null : json["companyName"],
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "userRole": userRole == null ? null : userRole,
        "subscription": subscription == null ? null : subscription,
        "createdAt": createdAt == null ? null : createdAt?.toIso8601String(),
        "fullName": fullName == null ? null : fullName,
        "state": state == null ? null : state,
        "city": city == null ? null : city,
        "isActive": isActive == null ? null : isActive,
        "userID": userId == null ? null : userId,
        "profilePicture": profilePicture == null ? null : profilePicture,
        "updatedAt": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "id": id == null ? null : id,
        "zipCode": zipCode == null ? null : zipCode,
        "street": street == null ? null : street,
        "hourlyFee": hourlyFee == null ? null : hourlyFee,
        "diagnosticFee": diagnosticFee == null ? null : diagnosticFee,
        "isOnline": isOnline == null ? null : isOnline,
        "companyName": companyName == null ? null : companyName,
        "longitude": longitude == null ? null : longitude,
        "latitude": latitude == null ? null : latitude,
      };
}

class VehiclesDetail {
  VehiclesDetail({
    this.model,
    this.createdAt,
    this.brand,
    this.email,
    this.make,
    this.image,
    this.updatedAt,
    this.isFavorite,
    this.plateNumber,
    this.tag,
    this.description,
    this.id,
    this.color,
    this.transmission,
  });

  String? model;
  DateTime? createdAt;
  String? brand;
  String? email;
  dynamic make;
  String? image;
  DateTime? updatedAt;
  bool? isFavorite;
  int? plateNumber;
  String? tag;
  String? description;
  String? id;
  String? color;
  String? transmission;

  factory VehiclesDetail.fromJson(Map<String, dynamic> json) => VehiclesDetail(
        model: json["model"],
        createdAt: DateTime.parse(json["createdAt"]),
        brand: json["brand"],
        email: json["email"],
        make: json["make"],
        image: json["image"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        isFavorite: json["isFavorite"],
        plateNumber: json["plateNumber"],
        tag: json["tag"],
        description: json["description"],
        id: json["id"],
        color: json["color"],
        transmission: json["transmission"],
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "createdAt": createdAt?.toIso8601String(),
        "brand": brand,
        "email": email,
        "make": make,
        "image": image,
        "updatedAt": updatedAt?.toIso8601String(),
        "isFavorite": isFavorite,
        "plateNumber": plateNumber,
        "tag": tag,
        "description": description,
        "id": id,
        "color": color,
        "transmission": transmission,
      };
}
