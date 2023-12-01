String? passwordController;
String? confirmPasswordController;

String? nameValidator(value) {
  RegExp regex = RegExp(r'^.{1,}$');
  if (value!.isEmpty) {
    return ("Field cannot be Empty");
  }
  if (!regex.hasMatch(value)) {
    return ("Enter Valid name(Min. 2 Character)");
  }
  return null;
}

bool? namValidator(value) {
  RegExp regex = RegExp(r'^.{1,}$');
  if (value!.isEmpty) {
    return true; //("Field cannot be Empty");
  }
  if (!regex.hasMatch(value)) {
    return true;
  }
  return null;
}

String? zipcodeValidator(value) {
  RegExp regex = RegExp(r'^.{5}$');
  if (value!.isEmpty) {
    return ("Field cannot be Empty");
  }
  if (!regex.hasMatch(value)) {
    return ("Zipcode must be only five number");
  }
  return null;
}

String? streetValidator(value) {
  if (value!.isEmpty) {
    return ("Field cannot be Empty");
  }
  return null;
}

String? emailValidator(value) {
  if (value!.isEmpty) {
    return ("Please Enter Your Email");
  }
  // reg expression for email validation
  if (!RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      .hasMatch(value.trim())) {
    return ("Please Enter a valid email");
  }

  return null;
}

String? phoneValidator(value) {
  if (value.isEmpty) {
    return ("Phone Number can not be Empty");
  }
  if (value.length < 10) {
    return ("Enter Valid PhoneNumber");
  }
  return null;
}

String? passwordValidator(value) {
  RegExp regex = RegExp(r'^.{8,}$');
  if (value!.isEmpty) {
    return ("Password is required for login");
  }
  if (!regex.hasMatch(value)) {
    return ("Enter Valid Password(Min. 8 Character)");
  }
  passwordController = value;

  if (confirmPasswordController != null) {
    confirmPasswordValidator(confirmPasswordController);
  }

  return null;
}

String? confirmPasswordValidator(value) {
  print("i am success $value $passwordController");
  confirmPasswordController = value;
  if (value != passwordController) {
    return "Password don't match $value $passwordController";
  }
  print("i am not success $value");

  return null;
}
