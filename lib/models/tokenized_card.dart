import 'dart:convert';

class TokenizedCard {
  String id;
  String tokenId;
  int length;
  String lastFour;
  String customerName;
  bool isActive;
  DateTime? updatedAt;
  DateTime? createdAt;
  String email;

  TokenizedCard({
    required this.id,
    required this.tokenId,
    required this.length,
    required this.lastFour,
    required this.customerName,
    required this.email,
    required this.isActive,
    this.updatedAt,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tokenId': tokenId,
      'length': length,
      'lastFour': lastFour,
      'customerName': customerName,
      'isActive': isActive,
      "updatedAt": updatedAt?.toIso8601String(),
      "createdAt": createdAt?.toIso8601String(),
      'email': email,
    };
  }

  factory TokenizedCard.fromMap(Map<String, dynamic> map) {
    return TokenizedCard(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      tokenId: map['tokenId'] ?? '',
      length: map['length'] ?? 0,
      lastFour: map['lastFour'] ?? '',
      customerName: map['customerName'] ?? '',
      isActive: map['isActive'] ?? '',
      updatedAt: DateTime.parse(map["updatedAt"]),
      createdAt: DateTime.parse(map["createdAt"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory TokenizedCard.fromJson(String source) =>
      TokenizedCard.fromMap(json.decode(source));

  String get hiddenCN =>
      '${List.generate(length - 4, (i) => i % 4 == 0 ? '* ' : '*').join()} $lastFour';
}
