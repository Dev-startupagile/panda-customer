// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:empty_widget/empty_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:panda/models/add_service_request_model.dart';
import 'package:panda/models/rejection_by_tech.dart';
import 'package:panda/provider/profile_provider.dart';
import 'package:panda/screens/home/profile/profileComponents/edit_specific_component.dart';
import 'package:panda/screens/home/services/service_request/componets/service_request_form.dart';
import 'package:panda/util/ui_constant.dart';
import 'package:provider/provider.dart';

import '../../../../commonComponents/loading_dialog.dart';
import '../../../../function/shared_prefs.dart';
import '../../../../util/constants.dart';

class RequestServicesMap extends StatefulWidget {
  const RequestServicesMap({super.key});

  @override
  State<RequestServicesMap> createState() => _RequestServicesMapState();
}

class _RequestServicesMapState extends State<RequestServicesMap> {
  late GoogleMapController _mapController;

  String mapState = "We are finding Your Location ...";
  bool isBrowse = false;
  double lat = 0;
  double long = 0;

  String? currentPosition;
  final dialog = DialogHandler();

  final Set<Marker> _markers = {};

  static LatLng _mainLocation = const LatLng(0.0, 0.0);

  final List<String> formSteps = <String>[
    serviceRequest,
    // assistance,
    whereAreYou,
    selectPaymentMethod,
    findingYourTechnician,
    // estimatedCost
    assignedTechnician
  ];

  Future<Position> _determinePosition() async {
    setState(() {
      mapState = "We are finding Your Location ...";
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      setState(() {
        mapState = "Location services are disabled";
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          mapState = "Location permissions are denied";
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        mapState =
            "Location permissions are permanently denied, we cannot request permissions.";
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    _mainLocation = LatLng(position.latitude, position.longitude);
    // _desLocation = LatLng(position.latitude, position.longitude);

    var newPosition = CameraPosition(target: _mainLocation, zoom: 10);

    CameraUpdate update = CameraUpdate.newCameraPosition(newPosition);

    _mapController.moveCamera(update);

    myMarker();

    setState(() {
      lat = position.latitude;
      long = position.longitude;
      currentPosition = position.toString();
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _determinePosition());
    // context
    //     .read<NearByProvider>()
    //     .nearBy(context, _mainLocation.latitude, _mainLocation.longitude, null,
    //         false)
    //     .then((value) => _markers.addAll(context
    //         .read<NearByProvider>()
    //         .nearby
    //         .map((e) => Marker(markerId: markerId))));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        if (notification.title == rejectedByTechN) {
          var data = RejectionByTech.fromJson(notification.body!);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return MaterialApp(
                home: AlertDialog(
                  title: const Text("Alert"),
                  content: Text(
                      "Sorry! ${data.technicianName} rejected the job. Do you want to select another technician?"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        // Close the dialog first
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ServiceRequestFormPage(
                                    addServiceRequestModel:
                                        AddServiceRequestModel(
                                            latitude: lat, longitude: long))));
                      },
                    ),
                    TextButton(
                      child: const Text("No thanks"),
                      onPressed: () {
                        // Close the dialog first
                        Navigator.pushNamed(context, "/home");
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    });
  }

  final sharedPrefs = SharedPrefs();

  void openCloseBrowse() {
    setState(() {
      isBrowse = !isBrowse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Stack(
          children: <Widget>[
            Positioned(
              width: 10,
              height: 10,
              right: 6,
              bottom: 22,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Panda Customer",
          style: KAppBodyTextStyle,
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapToolbarEnabled: true,
            buildingsEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _mainLocation,
              zoom: 14.5,
            ),
            polylines: const {},
            markers: //myMarker(),
                {
              Marker(
                  markerId: const MarkerId("source"), position: _mainLocation),
            },
            mapType: MapType.normal,
            onMapCreated: (controller) {
              // _controller.complete(controller);
              setState(() {
                _mapController = controller;
              });
            },
            onTap: (val) {
              print("clicked");
            },
            // ),
          ),
          Visibility(
            visible: currentPosition == null,
            child: Positioned(
                child: Center(
              child: EmptyWidget(
                image: "assets/logo.png",
                title: mapState,
                titleTextStyle: const TextStyle(
                  fontSize: 22,
                  color: Color(0xff9da9c7),
                  fontWeight: FontWeight.w500,
                ),
                subtitleTextStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xffabb8d6),
                ),
              ),
            )),
          ),
          Positioned(
            bottom: 0,
            child: Card(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: ElevatedButton(
                        onPressed: _serviceRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 65, vertical: 20),
                        ),
                        child: const Text(
                          'REQUEST SERVICE',
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 30,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.view_list,
                          size: 40,
                        ),
                        color: Colors.white,
                        onPressed: _serviceRequest,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _serviceRequest() async {
    if (currentPosition == null) {
      displayInfoSnackBar(context, "we are finding your location please wait");
    }
    if (context.read<ProfileProvider>().customerprofile == null) {
      await context.read<ProfileProvider>().customerProfile(context);
    }
    if (context
                .read<ProfileProvider>()
                .customerprofile!
                .personalInformation
                .fullName ==
            null ||
        context
            .read<ProfileProvider>()
            .customerprofile!
            .personalInformation
            .fullName!
            .isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditSpecificComponent(
            email: context
                    .read<ProfileProvider>()
                    .customerprofile!
                    .personalInformation
                    .id ??
                "",
            editType: fullNameConst,
            editData: context
                    .read<ProfileProvider>()
                    .customerprofile!
                    .personalInformation
                    .fullName ??
                '',
          ),
        ),
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ServiceRequestFormPage(
                  addServiceRequestModel:
                      AddServiceRequestModel(latitude: lat, longitude: long))));
    }

    // openCloseBrowse();
  }

  Set<Marker> myMarker() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_mainLocation.toString()),
        position: _mainLocation,
        infoWindow: const InfoWindow(
          title: 'Historical City',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    return _markers;
  }

  GlobalKey _markerKey = GlobalKey();

  // Future<BitmapDescriptor> createCustomMarkerBitmap(
  //     CustomMarkerWidget markerWidget) async {
  //   final RenderRepaintBoundary boundary =
  //       _markerKey.currentContext.findRenderObject();
  //   final image = await boundary.toImage(pixelRatio: 2.0);
  //   final byteData = await image.toByteData(format: ImageByteFormat.png);
  //   final Uint8List uint8List = byteData!.buffer.asUint8List();

  //   return BitmapDescriptor.fromBytes(uint8List);
  // }
}

class CustomMarkerWidget extends StatelessWidget {
  final bool isOnline;
  final String profilePicUrl;

  const CustomMarkerWidget({
    Key? key,
    required this.isOnline,
    required this.profilePicUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profilePicUrl),
            radius: 20,
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
            )
        ],
      ),
    );
  }
}
