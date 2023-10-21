
import 'dart:convert';

UploadImageModel uploadImageModelFromJson(String str) => UploadImageModel.fromJson(json.decode(str));

String uploadImageModelToJson(UploadImageModel data) => json.encode(data.toJson());

class UploadImageModel {
  UploadImageModel({
    required this.status,
    required this.message,
    required  this.result,
    required this.data,
  });

  String status;
  String message;
  Result result;
  Data data;

  factory UploadImageModel.fromJson(Map<String, dynamic> json) => UploadImageModel(
    status: json["status"],
    message: json["message"],
    result: Result.fromJson(json["result"]),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.fieldname,
    required  this.originalname,
    required this.encoding,
    required this.mimetype,
    required this.destination,
    required this.filename,
    required this.path,
    required this.size,
  });

  String fieldname;
  String originalname;
  String encoding;
  String mimetype;
  String destination;
  String filename;
  String path;
  int size;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    fieldname: json["fieldname"],
    originalname: json["originalname"],
    encoding: json["encoding"],
    mimetype: json["mimetype"],
    destination: json["destination"],
    filename: json["filename"],
    path: json["path"],
    size: json["size"],
  );

  Map<String, dynamic> toJson() => {
    "fieldname": fieldname,
    "originalname": originalname,
    "encoding": encoding,
    "mimetype": mimetype,
    "destination": destination,
    "filename": filename,
    "path": path,
    "size": size,
  };
}

class Result {
  Result({
    required this.eTag,
    required this.versionId,
    required this.location,
    required this.resultKey,
    required this.key,
    required this.bucket,
  });

  String eTag;
  String versionId;
  String location;
  String resultKey;
  String key;
  String bucket;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    eTag: json["ETag"],
    versionId: json["VersionId"],
    location: json["Location"],
    resultKey: json["key"],
    key: json["Key"],
    bucket: json["Bucket"],
  );

  Map<String, dynamic> toJson() => {
    "ETag": eTag,
    "VersionId": versionId,
    "Location": location,
    "key": resultKey,
    "Key": key,
    "Bucket": bucket,
  };
}
