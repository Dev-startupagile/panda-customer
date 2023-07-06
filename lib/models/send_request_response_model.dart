// To parse this JSON data, do
//
//     final sendRequestresponseModel = sendRequestresponseModelFromJson(jsonString);

import 'dart:convert';

SendRequestresponseModel sendRequestresponseModelFromJson(String str) => SendRequestresponseModel.fromJson(json.decode(str));

String sendRequestresponseModelToJson(SendRequestresponseModel data) => json.encode(data.toJson());

class SendRequestresponseModel {
  SendRequestresponseModel({
    required this.success,
    required this.code,
    required this.data,
  });

  bool success;
  int code;
  Data data;

  factory SendRequestresponseModel.fromJson(Map<String, dynamic> json) => SendRequestresponseModel(
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
    required this.id,
    required this.customerId,
    required this.serviceId,
    required  this.vehicleId,
    required this.serviceLocation,
    required this.schedule,
    required  this.price,
    required this.description,
    required this.requestStatus,
    required this.technicianId,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceDetail,
    required this.customerInfo,
  });

  String id;
  String customerId;
  String serviceId;
  List<String> vehicleId;
  ServiceLocation serviceLocation;
  Schedule schedule;
  Price price;
  Description description;
  String requestStatus;
  String technicianId;
  DateTime createdAt;
  DateTime updatedAt;
  ServiceDetail serviceDetail;
  CustomerInfo customerInfo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    customerId: json["customerId"],
    serviceId: json["serviceId"],
    vehicleId: List<String>.from(json["vehicleId"].map((x) => x)),
    serviceLocation: ServiceLocation.fromJson(json["serviceLocation"]),
    schedule: Schedule.fromJson(json["schedule"]),
    price: Price.fromJson(json["price"]),
    description: Description.fromJson(json["description"]),
    requestStatus: json["requestStatus"],
    technicianId: json["technicianId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    serviceDetail: ServiceDetail.fromJson(json["serviceDetail"]),
    customerInfo: CustomerInfo.fromJson(json["customerInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerId": customerId,
    "serviceId": serviceId,
    "vehicleId": List<dynamic>.from(vehicleId.map((x) => x)),
    "serviceLocation": serviceLocation.toJson(),
    "schedule": schedule.toJson(),
    "price": price.toJson(),
    "description": description.toJson(),
    "requestStatus": requestStatus,
    "technicianId": technicianId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "serviceDetail": serviceDetail.toJson(),
    "customerInfo": customerInfo.toJson(),
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
    required this.note,
    required this.attachments,
  });

  String note;
  List<String> attachments;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
    note: json["note"],
    attachments: List<String>.from(json["attachments"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "note": note,
    "attachments": List<dynamic>.from(attachments.map((x) => x)),
  };
}

class Price {
  Price({
    required this.diagnosticFee,
    required this.hourlyFee,
  });

  dynamic diagnosticFee;
  dynamic hourlyFee;

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

  String date;
  String time;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "time": time,
  };
}

class ServiceDetail {
  ServiceDetail({
    required  this.createdAt,
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
    required  this.longitude,
    required  this.latitude,
  });

  double longitude;
  double latitude;

  factory ServiceLocation.fromJson(Map<String, dynamic> json) => ServiceLocation(
    longitude: json["longitude"].toDouble(),
    latitude: json["latitude"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "longitude": longitude,
    "latitude": latitude,
  };
}