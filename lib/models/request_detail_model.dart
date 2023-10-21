// To parse this JSON data, do
//
//     final requestDetailModel = requestDetailModelFromJson(jsonString);

import 'dart:convert';

RequestDetailModel requestDetailModelFromJson(String str) => RequestDetailModel.fromJson(json.decode(str));

String requestDetailModelToJson(RequestDetailModel data) => json.encode(data.toJson());

class RequestDetailModel {
  RequestDetailModel({
    required this.success,
    required this.code,
    required this.data,
  });

  bool success;
  int code;
  Data data;

  factory RequestDetailModel.fromJson(Map<String, dynamic> json) => RequestDetailModel(
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
    required this.paymentId,
    required this.vehicleId,
    required this.technicianId,
    required this.createdAt,
    required this.schedule,
    required this.serviceLocation,
    required this.updatedAt,
    required this.serviceId,
    required this.description,
    required this.isDiagnosed,
    required this.price,
    required this.id,
    required this.requestStatus,
    required this.customerId,
    required this.serviceDetail,
    required this.customerInfo,
    required this.technicianInfo,
  });

  String paymentId;
  List<String> vehicleId;
  String technicianId;
  DateTime createdAt;
  Schedule schedule;
  ServiceLocation serviceLocation;
  DateTime updatedAt;
  String serviceId;
  Description description;
  bool isDiagnosed;
  Price price;
  String id;
  String requestStatus;
  String customerId;
  ServiceDetail serviceDetail;
  CustomerInfo customerInfo;
  TechnicianInfo technicianInfo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    paymentId: json["paymentId"],
    vehicleId: List<String>.from(json["vehicleId"].map((x) => x)),
    technicianId: json["technicianId"],
    createdAt: DateTime.parse(json["createdAt"]),
    schedule: Schedule.fromJson(json["schedule"]),
    serviceLocation: ServiceLocation.fromJson(json["serviceLocation"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    serviceId: json["serviceId"],
    description: Description.fromJson(json["description"]),
    isDiagnosed: json["isDiagnosed"],
    price: Price.fromJson(json["price"]),
    id: json["id"],
    requestStatus: json["requestStatus"],
    customerId: json["customerId"],
    serviceDetail: ServiceDetail.fromJson(json["serviceDetail"]),
    customerInfo: CustomerInfo.fromJson(json["customerInfo"]),
    technicianInfo: TechnicianInfo.fromJson(json["technicianInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "paymentId": paymentId,
    "vehicleId": List<dynamic>.from(vehicleId.map((x) => x)),
    "technicianId": technicianId,
    "createdAt": createdAt.toIso8601String(),
    "schedule": schedule.toJson(),
    "serviceLocation": serviceLocation.toJson(),
    "updatedAt": updatedAt.toIso8601String(),
    "serviceId": serviceId,
    "description": description.toJson(),
    "isDiagnosed": isDiagnosed,
    "price": price.toJson(),
    "id": id,
    "requestStatus": requestStatus,
    "customerId": customerId,
    "serviceDetail": serviceDetail.toJson(),
    "customerInfo": customerInfo.toJson(),
    "technicianInfo": technicianInfo.toJson(),
  };
}

class CustomerInfo {
  CustomerInfo({
    required this.phoneNumber,
    required this.userRole,
    required this.subscription,
    required this.createdAt,
    required this.fullName,
    required this.state,
    required this.city,
    required this.isActive,
     this.fcmToken,
    required this.userId,
    required this.profilePicture,
    required this.updatedAt,
    required this.id,
    required this.zipCode,
    required this.street,
  });

  String phoneNumber;
  String userRole;
  String subscription;
  DateTime createdAt;
  String fullName;
  String state;
  String city;
  bool isActive;
  String? fcmToken;
  String userId;
  String profilePicture;
  DateTime updatedAt;
  String id;
  int zipCode;
  String street;

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => CustomerInfo(
    phoneNumber: json["phoneNumber"],
    userRole: json["userRole"],
    subscription: json["subscription"],
    createdAt: DateTime.parse(json["createdAt"]),
    fullName: json["fullName"],
    state: json["state"],
    city: json["city"],
    isActive: json["isActive"],
    fcmToken: json["fcm_token"],
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
    "createdAt": createdAt.toIso8601String(),
    "fullName": fullName,
    "state": state,
    "city": city,
    "isActive": isActive,
    "fcm_token": fcmToken,
    "userID": userId,
    "profilePicture": profilePicture,
    "updatedAt": updatedAt.toIso8601String(),
    "id": id,
    "zipCode": zipCode,
    "street": street,
  };
}

class Description {
  Description({
    required this.title,
    required this.note,
    required this.attachments,
  });

  String title;
  String note;
  List<dynamic> attachments;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
    title: json["title"],
    note: json["note"],
    attachments: List<dynamic>.from(json["attachments"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "note": note,
    "attachments": List<dynamic>.from(attachments.map((x) => x)),
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

  factory ServiceDetail.fromJson(Map<String, dynamic> json) => ServiceDetail(
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

class ServiceLocation {
  ServiceLocation({
    required this.name,
    required this.longitude,
    required this.latitude,
  });

  String name;
  int longitude;
  double latitude;

  factory ServiceLocation.fromJson(Map<String, dynamic> json) => ServiceLocation(
    name: json["name"],
    longitude: json["longitude"],
    latitude: json["latitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "longitude": longitude,
    "latitude": latitude,
  };
}

class TechnicianInfo {
  TechnicianInfo({
    required this.phoneNumber,
    required this.userRole,
    required this.subscription,
    required this.createdAt,
    required this.fullName,
    required this.state,
    required this.city,
    required this.isActive,
    required this.fcmToken,
    required this.userId,
    required this.profilePicture,
    required this.updatedAt,
    required this.id,
    required this.zipCode,
    required this.street,
    required this.hourlyFee,
    required this.diagnosticFee,
    required this.isOnline,
    required this.companyName,
    required this.longitude,
    required this.latitude,
  });

  String phoneNumber;
  String userRole;
  String subscription;
  DateTime createdAt;
  String fullName;
  String state;
  String city;
  bool isActive;
  String fcmToken;
  String userId;
  String profilePicture;
  DateTime updatedAt;
  String id;
  int zipCode;
  String street;
  int hourlyFee;
  int diagnosticFee;
  bool isOnline;
  String companyName;
  double longitude;
  double latitude;

  factory TechnicianInfo.fromJson(Map<String, dynamic> json) => TechnicianInfo(
    phoneNumber: json["phoneNumber"],
    userRole: json["userRole"],
    subscription: json["subscription"],
    createdAt: DateTime.parse(json["createdAt"]),
    fullName: json["fullName"],
    state: json["state"],
    city: json["city"],
    isActive: json["isActive"],
    fcmToken: json["fcm_token"],
    userId: json["userID"],
    profilePicture: json["profilePicture"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    id: json["id"],
    zipCode: json["zipCode"],
    street: json["street"],
    hourlyFee: json["hourlyFee"],
    diagnosticFee: json["diagnosticFee"],
    isOnline: json["isOnline"],
    companyName: json["companyName"],
    longitude: json["longitude"]?.toDouble(),
    latitude: json["latitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "phoneNumber": phoneNumber,
    "userRole": userRole,
    "subscription": subscription,
    "createdAt": createdAt.toIso8601String(),
    "fullName": fullName,
    "state": state,
    "city": city,
    "isActive": isActive,
    "fcm_token": fcmToken,
    "userID": userId,
    "profilePicture": profilePicture,
    "updatedAt": updatedAt.toIso8601String(),
    "id": id,
    "zipCode": zipCode,
    "street": street,
    "hourlyFee": hourlyFee,
    "diagnosticFee": diagnosticFee,
    "isOnline": isOnline,
    "companyName": companyName,
    "longitude": longitude,
    "latitude": latitude,
  };
}
