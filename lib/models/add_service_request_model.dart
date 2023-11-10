class AddServiceRequestModel {
  String serviceId;
  double longitude;
  double latitude;
  String name;
  String date;
  String time;
  String note;
  String title;
  String paymentId;
  bool isScheduled;
  AddServiceRequestModel(
      {required this.serviceId,
      required this.longitude,
      required this.latitude,
      required this.name,
      required this.date,
      required this.time,
      required this.note,
      required this.title,
      required this.paymentId,
      required this.isScheduled});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["serviceId"] = serviceId;
    data["longitude"] = longitude;
    data["latitude"] = latitude;
    data["name"] = name;
    data["date"] = date;
    data["time"] = time;
    data["note"] = note;
    data["title"] = title;
    data["paymentId"] = paymentId;
    data["isScheduled"] = isScheduled;
    return data;
  }
}
