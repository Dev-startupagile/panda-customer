import 'dart:convert';

class RejectionByTech {
  final String technicianName;
  final String technicianId;
  final String requestId;
  final String serviceId;
  RejectionByTech({
    required this.technicianName,
    required this.technicianId,
    required this.requestId,
    required this.serviceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'technicianName': technicianName,
      'requestId': requestId,
      'serviceId': serviceId,
    };
  }

  factory RejectionByTech.fromMap(Map<String, dynamic> map) {
    return RejectionByTech(
      technicianId: map['technicianId'] ?? '',
      technicianName: map['technicianName'] ?? '',
      requestId: map['requestId'] ?? '',
      serviceId: map['serviceId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RejectionByTech.fromJson(String source) =>
      RejectionByTech.fromMap(json.decode(source));
}
