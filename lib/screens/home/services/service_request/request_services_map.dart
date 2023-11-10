import 'dart:async';

import 'package:empty_widget/empty_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:panda/models/rejection_by_tech.dart';
import 'package:panda/util/ui_constant.dart';

import '../../../../commonComponents/loading_dialog.dart';
import '../../../../function/shared_prefs.dart';
import '../../../../util/constants.dart';
import '../browse/browse_bottomsheet_widget.dart';
import 'request_bottomsheet_widget.dart';

class RequestServicesMap extends StatefulWidget {
  int currentFormStep;
  RequestServicesMap({super.key, required this.currentFormStep});

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
  static LatLng _desLocation = const LatLng(39.0, 8.0);

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
                        setState(() {
                          widget.currentFormStep = 3;
                        });
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

  void onClickNextButton() {
    setState(() {
      if (widget.currentFormStep > formSteps.length - 2) {
        widget.currentFormStep = -1;
      } else {
        widget.currentFormStep++;
      }
    });
  }

  final sharedPrefs = SharedPrefs();

  void onClickBackButton(String val) {
    setState(() {
      if (widget.currentFormStep > formSteps.length - 2) {
        widget.currentFormStep = -1;
      } else {
        widget.currentFormStep--;
      }
    });
  }

  void onClickClose() {
    setState(() {
      widget.currentFormStep = -1;
    });
  }

  void openCloseBrowse() {
    setState(() {
      isBrowse = !isBrowse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.currentFormStep != -1
          ? null
          : AppBar(
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
              onClickClose();
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
                        onPressed: () {
                          if (currentPosition == null) {
                            displayInfoSnackBar(context,
                                "we are finding your location please wait");
                          } else {
                            setState(() {
                              widget.currentFormStep = 0;
                            });
                          }
                        },
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
                        onPressed: () {
                          setState(() {
                            if (currentPosition == null) {
                              displayInfoSnackBar(context,
                                  "we are finding your location please wait");
                            } else {
                              setState(() {
                                widget.currentFormStep = 0;
                              });
                            }
                          });
                          // openCloseBrowse();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: isBrowse
          ? Browse(latitude: lat, longitude: long, getFunc: openCloseBrowse)
          : widget.currentFormStep != -1
              ? RequestBottomSheetWidget(
                  latitude: lat,
                  longtude: long,
                  currentPosition: currentPosition,
                  title: formSteps[widget.currentFormStep],
                  onClickNext: onClickNextButton,
                  onClickBack: (String value) {
                    onClickBackButton(value);
                  },
                  onClickClose: onClickClose)
              : null,
    );
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
}
