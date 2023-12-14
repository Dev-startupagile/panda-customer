// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers, must_be_immutable

import 'dart:io';
import 'package:panda/commonComponents/popup_dialog.dart';
import 'package:panda/models/rejection_by_tech.dart';
import 'package:panda/provider/rating_provider.dart';
import 'package:panda/provider/service_request_provider.dart';
import 'package:panda/screens/home/services/counter_offer.dart';
import 'package:panda/screens/home/services/rating.dart';
import 'package:panda/screens/home/services/request_offer.dart';
import 'package:panda/screens/home/services/service_request/componets/assigned_technician.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:panda/provider/profile_provider.dart';
import 'package:panda/screens/home/profile/Profile.dart';
import 'package:panda/screens/home/services/service_request/request_services_map.dart';
import 'package:provider/provider.dart';
import '../../function/auth.dart';
import '../../function/shared_prefs.dart';
import '../../provider/notification_provider.dart';
import 'estimate/estimate_page.dart';
import 'history/history_page.dart';

class HomePage extends StatefulWidget {
  dynamic argument;
  HomePage({this.argument, super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  int title = -1;
  List<int> indexList = [];
  late TutorialCoachMark tutorialCoachMark;

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();

  final sharedPrefs = SharedPrefs();
  bool isAllTabClicked = true;

  final authfunc = AuthFunc();

  void cancelServiceRequest(RejectionByTech data) {
    context
        .read<ServiceRequestProvider>()
        .cancelServiceRequest(context, data.serviceId);
  }

  void sendServiceRequest(String id, String requestId) async {
    await context
        .read<ServiceRequestProvider>()
        .updateServiceRequestByStatus(context, id, requestId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("New Technician Assigned"),
          content: const Text("Successfully Assigned New Technician!"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                // Close the dialog first
                Navigator.pushNamed(context, "/home");
              },
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      indexList.add(index);
    });
  }

  void initAllTabClicked() async {
    isAllTabClicked = await authfunc.isAllTabClicked();
    setState(() {
      isAllTabClicked = isAllTabClicked;
    });
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: const Color.fromRGBO(168, 168, 168, 0),
      textSkip: "Skip",
      alignSkip: Alignment.topLeft,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        sharedPrefs.setIsAllTabClicked();
        setState(() {
          isAllTabClicked = false;
        });
      },
      onClickTarget: (target) {
        // tutorialCoachMark.next();
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        // tutorialCoachMark.next();
      },
      onClickOverlay: (target) {
        // tutorialCoachMark.next();
      },
      onSkip: () {
        sharedPrefs.setIsAllTabClicked();
        setState(() {
          isAllTabClicked = false;
        });
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    targets.add(TargetFocus(
      identify: "Target 1",
      keyTarget: _one,
      contents: [
        TargetContent(
            align: ContentAlign.right,
            child: Container(
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Home",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Click here to see your service",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.Circle,
    ));

    targets.add(TargetFocus(
      identify: "Target 2",
      keyTarget: _two,
      contents: [
        TargetContent(
            align: ContentAlign.right,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Estimate",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Click here to see your estimate",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ))
      ],
      shape: ShapeLightFocus.Circle,
    ));

    targets.add(TargetFocus(
      identify: "Target 3",
      keyTarget: _three,
      contents: [
        TargetContent(
            align: ContentAlign.left,
            child: Container(
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "History",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Click here to see your History",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.Circle,
    ));

    targets.add(TargetFocus(
      identify: "Target 4",
      keyTarget: _four,
      contents: [
        TargetContent(
            align: ContentAlign.left,
            child: Container(
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "profile",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Click here to see or edit your profile",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.Circle,
    ));

    return targets;
  }

  @override
  void initState() {
    createTutorial();
    // Future.delayed(const Duration(seconds: 1), () {
    //   showTutorial();
    // });
    super.initState();
    // initAllTabClicked();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchApi();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // fetchApi();
    }
  }

  void showPendingRequestPopup() {
    if (context.read<NotificationProvider>().badge > 0) {
      showPopUpDialogBox(
          context,
          "Pending Service Estimate",
          "There is pending service estimate in your estimates page.",
          "cancle",
          "view", () {
        Navigator.pop(context);
      }, () {
        Navigator.pop(context);

        _onItemTapped(1);
      });
    }
  }

  void fetchApi() async {
    await sharedPrefs.getIsFromImagePicker();
    if (!sharedPrefs.isFromImagePicker) {
      await context.read<ProfileProvider>().customerProfile(context);
      await context.read<NotificationProvider>().getBadge();

      context.read<NotificationProvider>().getCounterOffer();
      context.read<NotificationProvider>().getRequestOffer();

      context.read<RatingProvider>().getRating();

      context.read<NotificationProvider>().getPendingBadge();
      context.read<NotificationProvider>().getAcceptedBadge();
      context.read<NotificationProvider>().getCanceledBadge();
      context.read<NotificationProvider>().getCompletedBadge();
    }
    showPendingRequestPopup();
    sharedPrefs.saveIsFromImagePicker(false);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  List<Widget> get widgetOptions => <Widget>[
        const RequestServicesMap(),
        const EstimatePage(),
        HistoryPage(
          isFromNearBy: false,
        ),
        const ProfilePage(),
      ];

  DateTime timeBackPresed = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: WillPopScope(
        onWillPop: () async {
          final diffrence = DateTime.now().difference(timeBackPresed);
          final isExitWarning = diffrence >= const Duration(seconds: 2);
          timeBackPresed = DateTime.now();
          if (isExitWarning) {
            return false;
          } else {
            exit(0);
          }
        },
        child: Scaffold(
          body: Center(
            child: widgetOptions.elementAt(_selectedIndex),
          ),
          bottomSheet: context.watch<RatingProvider>().isRatingActive
              ? RatingWidget(
                  to: "",
                  requestId: context.read<RatingProvider>().ratingRequestId,
                  callback: (_) {},
                )
              : context.watch<NotificationProvider>().isRequestScheduled
                  ? RequestOffer(
                      requestId: context
                          .read<NotificationProvider>()
                          .scheduleRequestId,
                    )
                  : context.watch<NotificationProvider>().isCounterOffer
                      ? CounterOffer(
                          requestId:
                              context.read<NotificationProvider>().requestId)
                      : widget.argument != null
                          ? AssignedTechnician(arg: widget.argument)
                          : null,
          bottomNavigationBar: Stack(
            children: [
              Visibility(
                visible: !isAllTabClicked,
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                          child: Center(
                        child: SizedBox(
                          key: _one,
                          height: 40,
                          width: 40,
                        ),
                      )),
                      Expanded(
                          child: Center(
                        child: SizedBox(
                          key: _two,
                          height: 40,
                          width: 40,
                        ),
                      )),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            key: _three,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            key: _four,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    title = -1;
                  });
                },
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(
                        icon: context.watch<NotificationProvider>().badge == 0
                            ? const Icon(Icons.price_check)
                            : badges.Badge(
                                badgeContent: Text(context
                                    .watch<NotificationProvider>()
                                    .badge
                                    .toString()),
                                child: const Icon(Icons.price_check),
                              ),
                        label: "Estimate"),
                    BottomNavigationBarItem(
                        icon: context
                                    .watch<NotificationProvider>()
                                    .historyBadge ==
                                0
                            ? const Icon(Icons.folder)
                            : badges.Badge(
                                badgeContent: Text(context
                                    .watch<NotificationProvider>()
                                    .historyBadge
                                    .toString()),
                                child: const Icon(Icons.folder),
                              ),
                        label: "History"),
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: "Profile")
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: const Color.fromARGB(255, 12, 12, 11),
                  showUnselectedLabels: true,
                  unselectedItemColor: const Color.fromARGB(55, 1, 2, 0),
                  onTap: _onItemTapped,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
