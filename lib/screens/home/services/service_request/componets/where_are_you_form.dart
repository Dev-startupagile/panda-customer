import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:panda/screens/home/services/service_request/componets/service_listtile.dart';
import 'package:panda/screens/home/services/service_request/componets/service_textfield.dart';
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

class WhereAreYou extends StatefulWidget {
  TextEditingController locationController;
  TextEditingController destinationController;
  TextEditingController noteController;
  String? dropdownValue;
  String serviceType;
  String? currentPlaceAddress;
  String vehicleId;
  List<XFile> images;
  final dynamic getSetDropdownFunc;
  bool isNotePressed;
  final dynamic getFunc;
  final dynamic getNotePressedFunc;
  final dynamic setVehicleId;
  final dynamic pickDateTime;
  final Function imageInit;
  final Function currentLocationSetter;
  final Function onScheduled;
  final dynamic removeVehicleId;
  DateTime dateTime;

  WhereAreYou(
      {required this.removeVehicleId,
      required this.currentLocationSetter,
      required this.imageInit,
      required this.currentPlaceAddress,
      required this.dateTime,
      required this.pickDateTime,
      required this.images,
      required this.setVehicleId,
      required this.vehicleId,
      required this.serviceType,
      required this.dropdownValue,
      required this.getSetDropdownFunc,
      required this.isNotePressed,
      required this.getNotePressedFunc,
      required this.getFunc,
      required this.locationController,
      required this.onScheduled,
      required this.destinationController,
      required this.noteController,
      Key? key})
      : super(key: key);

  @override
  State<WhereAreYou> createState() => _WhereAreYouState();
}

class _WhereAreYouState extends State<WhereAreYou> {
  final ScrollController _scrollController = ScrollController();
  String? serviceLocationQuery;
  final sharedPrefs = SharedPrefs();

  List<String> dropdownItems = [
    serviceTypeOne,
    serviceTypeTwo,
    serviceTypeThree,
    serviceTypeFour
  ];
  final ImagePicker imagePicker = ImagePicker();

  bool isScheduled = false;

  void _pickImage() async {
    await sharedPrefs.saveIsFromImagePicker(true);
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      setState(() {
        widget.images.addAll(selectedImages);
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
      widget.imageInit();
    });
  }

  Future _uploadProfilePic(BuildContext context) async {
    if (widget.images.isNotEmpty) {
      context
          .read<UploaderProvider>()
          .maltiImageUploader(context, widget.images);
    }
  }

  void addVehicle() {
    Navigator.pushNamed(context, "/add_vehicle");
  }

  void notesPressed() {
    widget.getNotePressedFunc(true);
  }

  void attachPhotos() {
    if (widget.images.length < 8) {
      _pickImage();
      // showSelectPhotoOptions(context,_pickImage);
    } else {
      displayErrorSnackBar(context, "image can not be more than 8");
    }
  }

  void timePressed() {
    widget.pickDateTime();
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        widget.isNotePressed
            ? Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  customNoteTextField(Icons.note, "text", widget.noteController,
                      "Notes", context, widget.getFunc)
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
                            widget.locationController,
                            "Service Location",
                            context,
                            widget.getFunc),
                        const Center(
                          child: Text(
                            "your current location",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (widget.currentPlaceAddress != null) {
                                widget.locationController.text =
                                    widget.currentPlaceAddress ?? "";
                                serviceLocationQuery = null;
                              }
                            });
                          },
                          child: ListTile(
                            leading: const Icon(Icons.location_pin),
                            title: Text(widget.currentPlaceAddress ??
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
                                                widget.locationController.text =
                                                    req?.description ?? "";
                                                serviceLocationQuery = null;
                                                widget.currentLocationSetter();
                                              });
                                            },
                                            child: ListTile(
                                              title:
                                                  Text(req?.description ?? ""),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "What Services are you experiencing issues with?",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Consumer<ProfileProvider>(builder: (context, value, child) {
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
                                  height: height * 0.25,
                                  child: ListView.builder(
                                      itemCount: value.customerprofile?.vehicles
                                          .items.length,
                                      shrinkWrap: false,
                                      scrollDirection: Axis.horizontal,
                                      controller: _scrollController,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            // if(widget.vehicleId.contains(value.customerprofile?.vehicles.items[index].id)) {
                                            //     widget.removeVehicleId(value.customerprofile?.vehicles.items[index].id);
                                            // }else{
                                            //
                                            // }
                                            widget.setVehicleId(value
                                                .customerprofile
                                                ?.vehicles
                                                .items[index]
                                                .id);
                                          },
                                          child: Card(
                                              shape: widget.vehicleId ==
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
                                                              Radius.circular(
                                                                  5)),
                                                      side: BorderSide(
                                                          width: 2,
                                                          color: kPrimaryColor))
                                                  : null,
                                              child: SizedBox(
                                                width: width * 0.65,
                                                child: SingleChildScrollView(
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
                                                                  .items[index]
                                                                  .image ??
                                                              "",
                                                          null),
                                                      SizedBox(
                                                        height: height * 0.01,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
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
                                                                    '${value.customerprofile?.vehicles.items[index].description}' ??
                                                                        "",
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
                      widget.vehicleId == ""
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
                                displayInfoSnackBar(
                                    context, "You already selected vehicle");
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
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
                                value: widget.dropdownValue,
                                hint: const Center(child: Text("Service type")),
                                isExpanded: true,
                                items: dropdownItems.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Center(child: Text(value)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  widget.getSetDropdownFunc(value.toString());
                                },
                              ),
                            ),
                            CheckboxListTile(
                              title: const Text('Do you want it scheduled?'),
                              value: isScheduled,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  if (newValue != null) {
                                    isScheduled = newValue;
                                    widget.onScheduled(newValue);
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
                                        .format(widget.dateTime),
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
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
                                    notesPressed),
                              ),
                              Visibility(
                                  visible:
                                      widget.noteController.text.isNotEmpty,
                                  child: Text(
                                      widget.noteController.text.length > 20
                                          ? '${widget.noteController.text.substring(0, 19)} ...'
                                          : widget.noteController.text,
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
                                    for (int i = 0;
                                        i < widget.images.length;
                                        i++)
                                      Container(
                                        // margin: EdgeInsets.only(right: 5),
                                        height: 80,
                                        width: 80,
                                        child: Stack(
                                          children: [
                                            Image.file(
                                              File(widget.images[i].path),
                                              width: 80,
                                              height: 80,
                                            ),
                                            Visibility(
                                              visible: context
                                                      .read<UploaderProvider>()
                                                      .uploadedFileList
                                                      .length ==
                                                  widget.images.length,
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: RawMaterialButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        widget.images
                                                            .removeAt(i);
                                                      });
                                                      context
                                                          .read<
                                                              UploaderProvider>()
                                                          .removeMultiImage(i);
                                                    },
                                                    elevation: 0.1,
                                                    fillColor: Colors.white10,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    shape: const CircleBorder(),
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
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
                  )
                ],
              ),
      ],
    );
  }
}
