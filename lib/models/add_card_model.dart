class AddCardModel {
  String cardNumber;
  String expiryDate;
  String cvc;
  String image;
  String type;
  AddCardModel({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvc,
    required this.image,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["cardNumber"] = cardNumber;
    data["expiryDate"] = expiryDate;
    data["cvc"] = cvc;
    data["image"] = image;
    data["type"] = type;

    return data;
  }

  String getLastFour() {
    if (cardNumber.length <= 4) {
      return cardNumber;
    } else {
      return cardNumber.substring(cardNumber.length - 4);
    }
  }
}
