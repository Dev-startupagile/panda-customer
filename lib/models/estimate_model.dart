
import 'dart:convert';

EstimateModel estimateModelFromJson(String str) => EstimateModel.fromJson(json.decode(str));

String estimateModelToJson(EstimateModel data) => json.encode(data.toJson());

class EstimateModel {
  EstimateModel({
    this.status,
    this.Count,
    this.ScannedCount,
    this.success,
    required this.code,
    required this.data,
  });

  bool? success;
  bool? status;
  int? Count;
  int? ScannedCount;
  int code;
  List<Datum> data;

  factory EstimateModel.fromJson(Map<String, dynamic> json) => EstimateModel(
    status: json["status"],
    Count: json["Count"],
    ScannedCount: json["ScannedCount"],

    success: json["success"],
    code: json["code"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Count": Count,
    "ScannedCount": ScannedCount,

    "success": success,
    "code": code,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.vehiclesDetail,
    this.sender,
    required this.items,
    this.totalEstimation,
    required this.note,
    required this.isApproved,
    required this.updatedAt,
    required this.createdAt,
    this.id,
    this.vat,
    this.discount,
    this.isCounterOffer,
    required  this.isRejected,
    this.requestId,
    this.title,
  });

  List<VehiclesDetail> vehiclesDetail;
  String? sender;
  List<Item> items;
  String? totalEstimation;
  String note;
  bool isApproved;
  DateTime updatedAt;
  DateTime createdAt;
  String? id;
  dynamic  vat;
  dynamic discount;
  bool? isCounterOffer;
  bool isRejected;
  String? requestId;
  String? title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    vehiclesDetail: List<VehiclesDetail>.from(json["vehiclesDetail"].map((x) => VehiclesDetail.fromJson(x))),
    sender: json["sender"],
    items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
    totalEstimation: json["totalEstimation"],
    note: json["note"],
    isApproved: json["isApproved"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
    id: json["id"],
    vat: json["vat"],
    discount: json["discount"],
    isCounterOffer: json["isCounterOffer"],
    isRejected: json["isRejected"],
    requestId: json["requestId"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "vehiclesDetail": List<dynamic>.from(vehiclesDetail.map((x) => x.toJson())),
    "sender": sender,
    "Items": List<dynamic>.from(items.map((x) => x.toJson())),
    "totalEstimation": totalEstimation,
    "note": note,
    "isApproved": isApproved,
    "updatedAt": updatedAt.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "id": id,
    "vat":vat,
    "isRejected": isRejected,
    "requestId": requestId,
    "title": title,
  };
}

class Item {
  Item({
    required this.title,
    required this.price,
  });

  String title;
  String price;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    title: json["title"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "price": price,
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
  String? make;
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
