String? expirationValidator(value) {
  if (value!.isEmpty) {
    return ("Expiration cannot be Empty");
  }

  return null;
}

String? cvcValidator(value) {
  RegExp regex =  RegExp(r'^.{3,}$');
  if (value!.isEmpty) {
    return ("CVC cannot be Empty");
  }
  if (!regex.hasMatch(value)) {
    return ("Enter Valid CVC(Min. 3 Character)");
  }
  return null;
}

String? cardValidator(value) {
  RegExp regex =  RegExp(r'^.{9,}$');
  if (value!.isEmpty) {
    return ("Card Number cannot be Empty");
  }
  if (!regex.hasMatch(value)) {
    return ("Enter Valid Card Number(Min. 9 Character)");
  }
  return null;
}