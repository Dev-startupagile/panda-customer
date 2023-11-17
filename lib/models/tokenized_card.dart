import 'dart:convert';

class TokenizedCard {
  String tokenId;
  int length;
  String lastFour;
  String customerName;
  bool isActive;
  TokenizedCard({
    required this.tokenId,
    required this.length,
    required this.lastFour,
    required this.customerName,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'tokenId': tokenId,
      'length': length,
      'lastFour': lastFour,
      'customerName': customerName,
      'isActive': isActive,
    };
  }

  factory TokenizedCard.fromMap(Map<String, dynamic> map) {
    return TokenizedCard(
      tokenId: map['tokenId'] ?? '',
      length: map['length'] ?? 0,
      lastFour: map['lastFour'] ?? '',
      customerName: map['customerName'] ?? '',
      isActive: map['isActive'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TokenizedCard.fromJson(String source) =>
      TokenizedCard.fromMap(json.decode(source));
}
