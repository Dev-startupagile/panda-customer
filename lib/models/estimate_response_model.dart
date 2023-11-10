
import 'dart:convert';

EstimateResponseModel estimateResponseModelFromJson(String str) => EstimateResponseModel.fromJson(json.decode(str));

String estimateResponseModelToJson(EstimateResponseModel data) => json.encode(data.toJson());

class EstimateResponseModel {
  EstimateResponseModel({
    required this.code,
    required this.data,
  });

  int code;
  Data data;

  factory EstimateResponseModel.fromJson(Map<String, dynamic> json) => EstimateResponseModel(
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.sender,
    required this.items,
    required this.totalEstimation,
    required this.note,
    required this.isApproved,
    required this.updatedAt,
    required this.createdAt,
    required this.isRejected,
    required this.requestId,
    required this.title,
  });

  String id;
  String sender;
  List<Item> items;
  String totalEstimation;
  String note;
  bool isApproved;
  DateTime updatedAt;
  DateTime createdAt;
  bool isRejected;
  String requestId;
  String title;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    sender: json["sender"],
    items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
    totalEstimation: json["totalEstimation"],
    note: json["note"],
    isApproved: json["isApproved"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
    isRejected: json["isRejected"],
    requestId: json["requestId"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender": sender,
    "Items": List<dynamic>.from(items.map((x) => x.toJson())),
    "totalEstimation": totalEstimation,
    "note": note,
    "isApproved": isApproved,
    "updatedAt": updatedAt.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
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
