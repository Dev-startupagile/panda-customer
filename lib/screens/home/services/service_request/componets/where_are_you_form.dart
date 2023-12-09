import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:panda/function/time_picker.dart';
import 'package:panda/models/add_service_request_model.dart';
import 'package:panda/screens/home/services/service_request/componets/request_service_btn.dart';
import 'package:panda/screens/home/services/service_request/componets/request_service_scaffold.dart';
import 'package:panda/screens/home/services/service_request/componets/select_payment_method_page.dart';
import 'package:panda/screens/home/services/service_request/componets/service_listtile.dart';
import 'package:panda/screens/home/services/service_request/componets/service_textfield.dart';
import 'package:panda/util/api.dart';
import 'package:provider/provider.dart';
import '../../../../../commonComponents/profile_avatar.dart';
import '../../../../../commonComponents/skeletal/custom_auto_complete_skeletal.dart';
import '../../../../../commonComponents/skeletal/custom_profile_skeletal.dart';
import '../../../../../function/global_snackbar.dart';
import '../../../../../function/shared_prefs.dart';
import '../../../../../provider/auto_complete_provider.dart';
import '../../../../../provider/profile_provider.dart';
import '../../../../../provider/uploader_provider.dart';
import '../../../../../util/constants.dart';
import '../../../../../util/ui_constant.dart';

class WhereAreYouPage extends StatefulWidget {
  final AddServiceRequestModel addServiceRequestModel;

  const WhereAreYouPage({required this.addServiceRequestModel, Key? key})
      : super(key: key);

  @override
  State<WhereAreYouPage> createState() => _WhereAreYouPageState();
}

class _WhereAreYouPageState extends State<WhereAreYouPage> {
  String? serviceLocationQuery;
  final sharedPrefs = SharedPrefs();
  String? currentPlaceAddress;
  DateTime dateTime = DateTime.now();

  final TextEditingController locationController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  List<String> dropdownItems = [
    serviceTypeOne,
    serviceTypeTwo,
    serviceTypeThree,
    serviceTypeFour
  ];
  String? dropdownValue;
  final LocatitonGeocoder geocoder = LocatitonGeocoder(googleApi);

  bool isNotePressed = false;
  void notePressed(bool value) {
    setState(() {
      isNotePressed = value;
    });
  }

  void setDropdownValue(String value) {
    setState(() {
      dropdownValue = value;
    });
  }

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> images = [];

  bool isScheduled = false;

  String vehicleId = "";

  void setVehicleId(String val) {
    setState(() {
      vehicleId = val;
      // vehicleId.insert(0, val);
    });
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate(context, dateTime);
    if (date == null) return;

    TimeOfDay? time = await pickTime(context, dateTime, date.day);
    if (time == null) return;
    final newDateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      dateTime = newDateTime;
    });
  }

  void _pickImage() async {
    await sharedPrefs.saveIsFromImagePicker(true);
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      setState(() {
        images.addAll(selectedImages);
        _uploadProfilePic(context);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UploaderProvider>().initialValue();
    });
  }

  Future _uploadProfilePic(BuildContext context) async {
    if (images.isNotEmpty) {
      context.read<UploaderProvider>().maltiImageUploader(context, images);
    }
  }

  void addVehicle() {
    Navigator.pushNamed(context, "/add_vehicle");
  }

  void attachPhotos() {
    if (images.length < 8) {
      _pickImage();
      // showSelectPhotoOptions(context,_pickImage);
    } else {
      displayErrorSnackBar(context, "image can not be more than 8");
    }
  }

  void timePressed() {
    pickDateTime();
  }

  void onChangeFunc(String query) {
    if (query == "") {
      setState(() {
        serviceLocationQuery = null;
      });
    } else {
      setState(() {
        serviceLocationQuery = query;
      });
    }
    context.read<AutoCompleteProvider>().getPlace(context, query);
  }

  void goToNext() {
    if (isNotePressed) {
      setState(() {
        isNotePressed = false;
      });
      return;
    }
    FocusScope.of(context).unfocus();
    if (vehicleId.isEmpty) {
      displayInfoSnackBar(context, "please select vehicle first");
    } else {
      if (locationController.text.isEmpty) {
        displayInfoSnackBar(context, "please enter your location");
      } else if (dropdownValue == null) {
        displayInfoSnackBar(context, "please select service type");
      } else {
        if (context.read<UploaderProvider>().uploadedFileList.length !=
            images.length) {
          displayInfoSnackBar(
              context, "please wait until your attachments uploaded ");
        } else {
          widget.addServiceRequestModel.name = locationController.text;
          widget.addServiceRequestModel.date = dateTime.toIso8601String();
          widget.addServiceRequestModel.time = dateTime.toIso8601String();
          widget.addServiceRequestModel.isScheduled = isScheduled;
          widget.addServiceRequestModel.note = noteController.text;
          widget.addServiceRequestModel.title = dropdownValue;

          widget.addServiceRequestModel.vehicleId = vehicleId;

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectPaymentMethodPage(
                      addServiceRequestModel: widget.addServiceRequestModel)));
        }
      }
    }
  }

  void currentServiceLocationSetter() async {
    //Location provider serivice
    final address = await geocoder.findAddressesFromCoordinates(Coordinates(
        widget.addServiceRequestModel.latitude,
        widget.addServiceRequestModel.longitude));
    setState(() {
      currentPlaceAddress = address.first.addressLine;
    });
  }

  void currentLocationSetter() {
    setState(() {
      currentPlaceAddress = null;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return RequestServiceScaffold(
      title: "Service Detail",
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            isNotePressed
                ? Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      customNoteTextField(
                          Icons.note, "text", noteController, "Notes", context),
                      RequestServiceBtn(
                          title: "Save",
                          onTap: () {
                            setState(() {
                              isNotePressed = !isNotePressed;
                            });
                          })
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Center(
                        child: Text(
                          "Please provide your vehicles current location.",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customServiceTextField(
                              Icons.location_pin,
                              onChangeFunc,
                              "text",
                              locationController,
                              "Service Location",
                              context,
                            ),
                            const Center(
                              child: Text(
                                "your current location",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (currentPlaceAddress != null) {
                                    locationController.text =
                                        currentPlaceAddress ?? "";
                                    serviceLocationQuery = null;
                                  }
                                });
                              },
                              child: ListTile(
                                leading: const Icon(Icons.location_pin),
                                title: Text(currentPlaceAddress ??
                                    "We are finding your current location"),
                              ),
                            ),
                            if (serviceLocationQuery != null)
                              Consumer<AutoCompleteProvider>(
                                  builder: (context, value, child) {
                                return value.isLoading
                                    ? ListView.builder(
                                        itemCount: 3,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return const CustomAutoCompleteCardSkeletal();
                                        })
                                    : ListView.builder(
                                        itemCount: value.placeList?.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final req = value.placeList![index];
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    locationController.text =
                                                        req?.description ?? "";
                                                    serviceLocationQuery = null;
                                                    currentLocationSetter();
                                                  });
                                                },
                                                child: ListTile(
                                                  title: Text(
                                                      req?.description ?? ""),
                                                ),
                                              ),
                                              const Divider()
                                            ],
                                          );
                                        });
                              }),
                          ]),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(height: 25),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Vehicle",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "What Services are you experiencing issues with?",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Consumer<ProfileProvider>(
                          builder: (context, value, child) {
                        return value.isLoading
                            ? const CustomProfileSkeletal()
                            : value.customerprofile!.vehicles.items.isEmpty
                                ? const Center(
                                    child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "no vehicle",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ))
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 210,
                                      child: ListView.builder(
                                          itemCount: value.customerprofile
                                              ?.vehicles.items.length,
                                          shrinkWrap: false,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                setVehicleId(value
                                                    .customerprofile!
                                                    .vehicles
                                                    .items[index]
                                                    .id);
                                              },
                                              child: Card(
                                                  shape: vehicleId ==
                                                          value
                                                              .customerprofile
                                                              ?.vehicles
                                                              .items[index]
                                                              .id
                                                      ?
                                                      // shape:widget.vehicleId.contains(value.customerprofile?.vehicles.items[index].id)?
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          side: BorderSide(
                                                              width: 2,
                                                              color:
                                                                  kPrimaryColor))
                                                      : null,
                                                  child: SizedBox(
                                                    width: width * 0.5,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        vehicleAvatar(
                                                            true,
                                                            value
                                                                    .customerprofile
                                                                    ?.vehicles
                                                                    .items[
                                                                        index]
                                                                    .image ??
                                                                "",
                                                            null),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      value
                                                                              .customerprofile
                                                                              ?.vehicles
                                                                              .items[index]
                                                                              .brand ??
                                                                          "",
                                                                      style:
                                                                          KLatoTextStyle,
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Text(
                                                                      '${value.customerprofile?.vehicles.items[index].description}',
                                                                      style:
                                                                          KLatoRegularTextStyle,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Icon(
                                                                Icons
                                                                    .square_rounded,
                                                                size: 30,
                                                                color: Color(
                                                                    int.parse(
                                                                        "0xff${value.customerprofile?.vehicles.items[index].color}")))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            );
                                          }),
                                    ),
                                  );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          vehicleId == ""
                              ? TextButton(
                                  onPressed: () {
                                    addVehicle();
                                  },
                                  child: const Text(
                                    'ADD VEHICLE',
                                    style: AdditemTextStyle,
                                  ),
                                )
                              : TextButton(
                                  onPressed: () {
                                    displayInfoSnackBar(context,
                                        "You already selected vehicle");
                                  },
                                  child: Text(
                                    'ADD VEHICLE',
                                    style: KNormalTextStyle,
                                  ),
                                ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  "When do you need assistance?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      "you can request help as soon as possible, or schedule it for some time in the future."),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: DropdownButton<String>(
                                    value: dropdownValue,
                                    hint: const Center(
                                        child: Text("Service type")),
                                    isExpanded: true,
                                    items: dropdownItems.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Center(child: Text(value)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setDropdownValue(value.toString());
                                    },
                                  ),
                                ),
                                CheckboxListTile(
                                  title:
                                      const Text('Do you want it scheduled?'),
                                  value: isScheduled,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      if (newValue != null) {
                                        isScheduled = newValue;
                                        widget.addServiceRequestModel
                                            .isScheduled = isScheduled;
                                      }
                                    });
                                  },
                                  secondary: const Icon(Icons.schedule),
                                  controlAffinity: ListTileControlAffinity
                                      .leading, // You can change this to ListTileControlAffinity.trailing if you prefer the checkbox at the end
                                ),
                                Material(
                                    elevation: 0.5,
                                    shadowColor: kPrimaryColor,
                                    color: Colors.white,
                                    child: customServiceListTile(
                                        null,
                                        DateFormat('MM/dd/yyyy hh:mm a')
                                            .format(dateTime),
                                        Icons.arrow_forward_ios_sharp,
                                        timePressed)),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Center(
                                child: Text(
                                  "Anything else?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                  "Please provide any additional details you feel are important."),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: [
                                  Material(
                                    elevation: 0.5,
                                    shadowColor: kPrimaryColor,
                                    color: Colors.white,
                                    child: customServiceListTile(
                                        Icons.line_style_rounded,
                                        "Notes",
                                        Icons.arrow_forward_ios_sharp,
                                        () => notePressed(true)),
                                  ),
                                  Visibility(
                                      visible: noteController.text.isNotEmpty,
                                      child: Text(
                                          noteController.text.length > 20
                                              ? '${noteController.text.substring(0, 19)} ...'
                                              : noteController.text,
                                          style: KHintTextStyle))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Material(
                                elevation: 0.5,
                                shadowColor: kPrimaryColor,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    customServiceListTile(
                                        Icons.photo,
                                        "Attach Photos",
                                        Icons.arrow_forward_ios_sharp,
                                        attachPhotos),
                                    Wrap(
                                      children: [
                                        for (int i = 0; i < images.length; i++)
                                          SizedBox(
                                            // margin: EdgeInsets.only(right: 5),
                                            height: 80,
                                            width: 80,
                                            child: Stack(
                                              children: [
                                                Image.file(
                                                  File(images[i].path),
                                                  width: 80,
                                                  height: 80,
                                                ),
                                                Visibility(
                                                  visible: context
                                                          .read<
                                                              UploaderProvider>()
                                                          .uploadedFileList
                                                          .length ==
                                                      images.length,
                                                  child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: RawMaterialButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            images.removeAt(i);
                                                          });
                                                          context
                                                              .read<
                                                                  UploaderProvider>()
                                                              .removeMultiImage(
                                                                  i);
                                                        },
                                                        elevation: 0.1,
                                                        fillColor:
                                                            Colors.white10,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1.0),
                                                        shape:
                                                            const CircleBorder(),
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                          size: 15.0,
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Visibility(
                                        visible: context
                                            .watch<UploaderProvider>()
                                            .isMultiLoading,
                                        child: const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.greenAccent),
                                        ))
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      RequestServiceBtn(onTap: goToNext)
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
