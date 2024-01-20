import 'dart:io';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panda/commonComponents/buttons/main_button.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:panda/provider/profile_provider.dart';
import 'package:panda/screens/auth/authComponent/auth_textfield.dart';
import 'package:panda/screens/home/profile/profileComponents/list_tile.dart';
import 'package:provider/provider.dart';

import '../../../../commonComponents/image_picker_bottomsheet.dart';
import '../../../../commonComponents/popup_dialog.dart';
import '../../../../commonComponents/profile_avatar.dart';
import '../../../../function/image_cropper.dart';
import '../../../../models/add_vehicle_form_model.dart';
import '../../../../provider/uploader_provider.dart';
import '../../../../util/ui_constant.dart';

class AddVehicle extends StatefulWidget {
  AddVehicle({Key? key}) : super(key: key);

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final _formKey = GlobalKey<FormState>();
  File? _image;

  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> customSwatches =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(const Color(0xff0000FF)): 'Blue',
    ColorTools.createPrimarySwatch(const Color(0xffFF0000)): 'Red',
    ColorTools.createPrimarySwatch(const Color(0xffffff00)): 'Yellow',
    ColorTools.createPrimarySwatch(const Color(0xff00FF00)): 'Green',
    ColorTools.createAccentSwatch(const Color(0xff454545)): 'Black',
    ColorTools.createAccentSwatch(const Color(0xffffffff)): 'White',
    ColorTools.createAccentSwatch(const Color(0xff999999)): 'Grey',
  };

  late TextEditingController _brand;
  late TextEditingController _model;
  late TextEditingController _make;
  String? _selectedTransmission;
  String? _selectedFuelType;
  final List<String> _transmissions = [
    'Automatic',
    'Manual',
    'Semi-Automatic',
    // Add more transmission types here
  ];
  final List<String> _fuelTypes = [
    'Petrol (Gasoline)',
    'Diesel',
    'Ethanol',
    'Biodiesel',
    'Electricity',
    'Hydrogen',
    'Compressed Natural Gas (CNG)',
    'Liquefied Petroleum Gas (LPG)',
    'Liquefied Natural Gas (LNG)',
    'Hybrids',
  ];
  late TextEditingController _plateNumber;
  late TextEditingController _description;
  late TextEditingController _tag;
  DateTime timeBackPresed = DateTime.now();

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xffffff00);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void yesBack() {
    Navigator.pop(context);
  }

  void submitData() {
    _formKey.currentState!.save();

    if (_model.text.isNotEmpty &&
        _make.text.isNotEmpty &&
        _selectedFuelType != null &&
        _selectedFuelType!.isNotEmpty &&
        _selectedTransmission != null &&
        _selectedTransmission!.isNotEmpty &&
        _plateNumber.text.isNotEmpty &&
        _tag.text.isNotEmpty) {
      if (_image == null) {
        displayErrorSnackBar(context, "please add image first");
      } else if (context.read<UploaderProvider>().uplodedFile == null) {
        displayErrorSnackBar(context, "please wait until image uploaded");
      } else {
        AddVehicleModel addvehicle = AddVehicleModel(
            brand: "${_make.text} ${_model.text}",
            model: _model.text,
            make: _make.text,
            transmission: _selectedTransmission!,
            plateNumber: int.parse(_plateNumber.text),
            image: context.read<UploaderProvider>().uplodedFile ?? "",
            color: currentColor.hex,
            description: _description.text.isEmpty ? " " : _description.text,
            fuelType: _selectedFuelType,
            tag: _tag.text);
        context.read<ProfileProvider>().addVehicle(context, addvehicle);
      }
    } else {
      displayErrorSnackBar(context, "please insert required field");
    }
  }

  Future isColorPickerClicked() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          backgroundColor: Colors.white70,
          content: SingleChildScrollView(
            child: ColorPicker(
              borderColor: pickerColor,
              onColorChanged: changeColor,
              enableShadesSelection: false,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: false,
                ColorPickerType.accent: false,
                ColorPickerType.bw: false,
                ColorPickerType.custom: true,
                ColorPickerType.wheel: false,
              },
              customColorSwatchesAndNames: customSwatches,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _brand = TextEditingController();
    _model = TextEditingController();
    _plateNumber = TextEditingController();
    _selectedTransmission = _transmissions.first;
    _selectedFuelType = _fuelTypes.first;
    _make = TextEditingController();
    _tag = TextEditingController();
    _description = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _brand.dispose();
    _model.dispose();
    _plateNumber.dispose();
    _make.dispose();
    _tag.dispose();
    _description.dispose();

    super.dispose();
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(imageFile: img);
      setState(() {
        _image = img;
        _uploadProfilePic(context);
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  void _onTransmissionChanged(String? newValue) {
    setState(() {
      _selectedTransmission = newValue;
    });
  }

  void _onFuelTypeChanged(String? newValue) {
    setState(() {
      _selectedFuelType = newValue;
    });
  }

  Future _uploadProfilePic(BuildContext context) async {
    if (_image != null) {
      context.read<UploaderProvider>().imageUploader(context, _image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    void goBack() {
      showPopupDialog(context, "Go Back", height, width, yesBack);
    }

    return WillPopScope(
      onWillPop: () async {
        final diffrence = DateTime.now().difference(timeBackPresed);
        final isExitWarning = diffrence >= const Duration(seconds: 2);
        timeBackPresed = DateTime.now();
        if (isExitWarning) {
          return false;
        } else {
          goBack();
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Vehicle',
            style: KProfilePicAppBarTextStyle,
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              goBack();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: KPColor,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showSelectPhotoOptions(context, _pickImage);
                        },
                        child: Stack(children: [
                          vehicleAvatar(true, "", _image),
                          if (context.watch<UploaderProvider>().isLoading)
                            const Positioned(
                              bottom: 50,
                              right: 100,
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            ),
                          const Positioned(
                            bottom: 0,
                            right: 5,
                            child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.photo_camera,
                                    size: 23, color: Colors.white)),
                          ),
                        ]),
                      ),
                      CustomAuthTextField(
                          isTag: false,
                          isState: false,
                          isNumber: true,
                          icon: Icons.confirmation_number_sharp,
                          nameController: _plateNumber,
                          hintText: "Year",
                          submitData: submitData,
                          isEmail: false,
                          isCity: false,
                          isZipCode: false,
                          isStreet: false,
                          isPassword: false,
                          isConfirmPassword: false),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomAuthTextField(
                          isTag: false,
                          isState: false,
                          isNumber: false,
                          icon: Icons.time_to_leave,
                          nameController: _make,
                          hintText: "Make",
                          submitData: submitData,
                          isEmail: false,
                          isCity: false,
                          isZipCode: false,
                          isStreet: false,
                          isPassword: false,
                          isConfirmPassword: false),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomAuthTextField(
                          isTag: false,
                          isState: false,
                          isNumber: false,
                          icon: Icons.model_training_sharp,
                          nameController: _model,
                          hintText: "Model",
                          submitData: submitData,
                          isEmail: false,
                          isCity: false,
                          isZipCode: false,
                          isStreet: false,
                          isPassword: false,
                          isConfirmPassword: false),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.merge_type,
                            color: KHintColor,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedTransmission,
                              icon: const Icon(Icons.arrow_drop_down),
                              decoration: const InputDecoration(
                                labelText: 'Transmission',
                                // Add other decoration properties if needed
                              ),
                              onChanged: _onTransmissionChanged,
                              items: _transmissions
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.branding_watermark,
                            color: KHintColor,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedFuelType,
                              icon: const Icon(Icons.arrow_drop_down),
                              decoration: const InputDecoration(
                                labelText: 'Fuel Type',
                                // Add other decoration properties if needed
                              ),
                              onChanged: _onFuelTypeChanged,
                              items: _fuelTypes.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomAuthTextField(
                          isTag: true,
                          isState: false,
                          isNumber: false,
                          icon: Icons.tag,
                          nameController: _tag,
                          hintText: "Tag",
                          submitData: submitData,
                          isEmail: false,
                          isCity: false,
                          isZipCode: false,
                          isStreet: false,
                          isPassword: false,
                          isConfirmPassword: false),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomAuthTextField(
                          isDescription: true,
                          isTag: false,
                          isState: false,
                          isNumber: false,
                          icon: Icons.description,
                          nameController: _description,
                          hintText: "Description",
                          submitData: submitData,
                          isEmail: false,
                          isCity: false,
                          isZipCode: false,
                          isStreet: false,
                          isPassword: false,
                          isConfirmPassword: false),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                          elevation: 1.0,
                          shadowColor: kPrimaryColor,
                          child: Column(
                            children: [
                              customListTile(
                                  Icons.color_lens,
                                  "Color",
                                  Icons.arrow_forward_ios_sharp,
                                  isColorPickerClicked,
                                  null),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Your current color",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.square_rounded,
                                    size: 30,
                                    color: currentColor,
                                  )
                                ],
                              ),
                            ],
                          )),
                      mainButton("Add Vehicle", submitData, kPrimaryColor)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
