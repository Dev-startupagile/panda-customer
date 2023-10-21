// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:panda/screens/home/history/status/request_page.dart';
import 'package:panda/util/constants.dart';
import 'package:provider/provider.dart';

import '../../../provider/notification_provider.dart';
import 'package:badges/badges.dart' as badges;

class HistoryPage extends StatelessWidget {
  bool isFromNearBy;
  HistoryPage({Key? key, required this.isFromNearBy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    TabBar _tabBar = TabBar(
      unselectedLabelColor: Colors.black,
      labelStyle: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
      indicator: const BoxDecoration(
        color: Colors.black,
      ),
      tabs: <Widget>[
        SizedBox(
          height: height * 0.2,
          width: double.infinity,
          child: context.watch<NotificationProvider>().pendingBadge != 0
              ? badges.Badge(
                  badgeContent: Text(context
                      .watch<NotificationProvider>()
                      .pendingBadge
                      .toString()),
                  child: const Tab(
                    text: "Pending",
                  ),
                )
              : const Tab(
                  text: "Pending",
                ),
        ),
        SizedBox(
          height: height * 0.2,
          width: double.infinity,
          child: context.watch<NotificationProvider>().acceptedBadge != 0
              ? badges.Badge(
                  badgeContent: Text(context
                      .watch<NotificationProvider>()
                      .acceptedBadge
                      .toString()),
                  child: const Tab(
                    text: "Accepted",
                  ),
                )
              : const Tab(
                  text: "Accepted",
                ),
        ),
        SizedBox(
          height: height * 0.2,
          width: double.infinity,
          child: context.watch<NotificationProvider>().cancelBadge != 0
              ? badges.Badge(
                  badgeContent: Text(context
                      .watch<NotificationProvider>()
                      .cancelBadge
                      .toString()),
                  child: const Tab(
                    text: "Canceled",
                  ),
                )
              : const Tab(
                  text: "Canceled",
                ),
        ),
        SizedBox(
          height: height * 0.2,
          width: double.infinity,
          child: context.watch<NotificationProvider>().completedBadge != 0
              ? badges.Badge(
                  badgeContent: Text(context
                      .watch<NotificationProvider>()
                      .completedBadge
                      .toString()),
                  child: const Tab(
                    text: "Completed",
                  ),
                )
              : const Tab(
                  text: "Completed",
                ),
        ),
      ],
    );

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text(''),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: Material(
              child: Container(
                height: 75,
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Card(
                  elevation: 2,
                  child: _tabBar,
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(children: <Widget>[
          RequestPage(isFromNearBy: isFromNearBy, status: pendingConst),
          RequestPage(isFromNearBy: isFromNearBy, status: acceptedConst),
          RequestPage(isFromNearBy: isFromNearBy, status: canceledConst),
          RequestPage(
              isFromNearBy: isFromNearBy, status: completedDiagnosticConst),
        ]),
      ),
    );
  }
}
