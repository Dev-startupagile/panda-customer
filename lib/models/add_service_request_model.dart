class AddServiceRequestModel {
  String? serviceId;
  String? serviceType;
  double? longitude;
  double? latitude;
  String? name;
  String? date;
  String? time;
  String? note;
  String? title;
  String? paymentId;
  String? vehicleId;
  bool? isScheduled;
  AddServiceRequestModel(
      {this.serviceId,
      this.serviceType,
      this.longitude,
      this.latitude,
      this.name,
      this.date,
      this.time,
      this.note,
      this.title,
      this.paymentId,
      this.vehicleId,
      this.isScheduled});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["serviceId"] = serviceId;
    data["serviceType"] = serviceType;
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
