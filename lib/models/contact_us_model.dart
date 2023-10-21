
class AddContactUsModel{
  String from;
  String subject;
  String message;

  AddContactUsModel({
    required this.from,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["from"] = from;
    data["subject"] = subject;
    data["message"] = message;

    return data;
  }
}