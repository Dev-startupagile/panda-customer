class SignUpModel{
  String firstName;
  String lastName;
  String profilePicture;
  String email;
  String phoneNumber;
  String password;
  String street;
  String city;
  String state;
  int zipCode;
  String userRole;
  String fcm_token;

  SignUpModel({
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.email,
    required this.phoneNumber,
    required this.state,
    required this.city,
    required this.password,
    required this.zipCode,
    required this.userRole,
    required this.street,
    required this.fcm_token
  });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["firstName"] = firstName;
    data["lastName"] = lastName;
    data["profilePicture"] = profilePicture;
    data["email"] = email;
    data["phoneNumber"] = phoneNumber;
    data["state"] = state;
    data['city'] = city;
    data['password'] = password;
    data['zipCode'] = zipCode;
    data['userRole'] = userRole;
    data['street'] = street;
    data['fcm_token'] = fcm_token;

    return data;
  }
}
