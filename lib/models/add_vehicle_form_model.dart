class AddVehicleModel{
  String brand;
  String model;
  String make;
  String transmission;
  int plateNumber;
  String image;
  String color;
  String description;
  String tag;


  AddVehicleModel({
    required this.brand,
    required this.model,
    required this.make,
    required this.transmission,
    required this.plateNumber,
    required this.image,
    required this.color,
    required this.description,
    required this.tag
  });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["brand"] = brand;
    data["model"] = model;
    data["make"] = make;
    data["transmission"] = transmission;
    data["plateNumber"] = plateNumber;
    data["image"] = image;
    data['color'] = color;
    data['description'] = description;
    data['tag'] = tag;
    return data;
  }
}