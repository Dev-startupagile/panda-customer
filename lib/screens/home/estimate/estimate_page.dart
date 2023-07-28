import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda/commonComponents/profile_avatar.dart';
import 'package:panda/screens/home/estimate/reschedule_page.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../commonComponents/skeletal/custom_card_skeletal.dart';
import '../../../models/estimate_model.dart';
import '../../../provider/estimate_provider.dart';
import '../../../provider/notification_provider.dart';
import '../../../util/constants.dart';
import '../../../util/ui_constant.dart';
import 'estimate_detail.dart';

class EstimatePage extends StatefulWidget {
  const EstimatePage({Key? key}) : super(key: key);

  @override
  State<EstimatePage> createState() => _EstimatePageState();
}

class _EstimatePageState extends State<EstimatePage> {
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isDetail = false;
  late Datum estimateDetail;

  final List<String> titles = <String>[reSchedule, reSchedule];

  int title = -1;

  void onClickNextButton() {
    setState(() {
      if (title > titles.length - 2) {
        title = -1;
      } else {
        title++;
      }
    });
  }

  void estimationSetter(Datum req) {
    setState(() {
      estimateDetail = req;
      title = 0;
    });
  }

  void onClickBackButton() {
    setState(() {
      if (title > titles.length - 2) {
        title = -1;
      } else {
        title--;
      }
    });
  }

  void onClickClose() {
    setState(() {
      title = -1;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchEstimate();
    removeBadge();
  }

  void removeBadge() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().updateBadge();
    });
  }

  void fetchEstimate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EstimateProvider>().getEstimate(context);
    });
  }

  void refreshEstimate() {
    context.read<EstimateProvider>().getEstimate(context);
  }

  void showDetail(req) {
    setState(() {
      estimateDetail = req;
      isDetail = true;
    });
  }

  void hideDetail() {
    setState(() {
      isDetail = false;
    });
  }

  void decline() async {
    await context
        .read<EstimateProvider>()
        .declineEstimate(context, estimateDetail.id);
    hideDetail();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshEstimate();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estimate',
          style: KProfilePicAppBarTextStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = const Text("release to load more");
            } else {
              body = const Text("No more Data");
            }
            return SizedBox(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: SingleChildScrollView(
          child: isDetail
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isDetail = false;
                            });
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                    ],
                  ),
                  EstimateDetail(
                    hideDetail: hideDetail,
                    refreshPage: fetchEstimate,
                    estimateDetail: estimateDetail,
                    estimationSetter: estimationSetter,
                  )
                ])
              : Consumer<EstimateProvider>(builder: (context, value, child) {
                  return value.estimates.isEmpty && value.isLoaded
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 45,
                            ),
                            EmptyWidget(
                              image: "assets/logo.png",
                              title: 'No Estimation',
                              subTitle: 'No Estimation available yet',
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
                          ],
                        )
                      : value.isLoading
                          ? ListView.builder(
                              itemCount: 7,
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return const CustomCardSkeletal();
                              })
                          : ListView.builder(
                              itemCount: value.estimates.length,
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                final req = value.estimates[index];
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          estimateDetail = req;
                                          isDetail = true;
                                        });
                                      },
                                      child: Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListView.builder(
                                              itemCount:
                                                  req.vehiclesDetail.length,
                                              shrinkWrap: true,
                                              controller: _scrollController,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  leading: vehicleAvatar(
                                                      false,
                                                      req.vehiclesDetail[index]
                                                          .image,
                                                      null),
                                                  title: Text(
                                                    req.vehiclesDetail[index]
                                                            .model ??
                                                        "",
                                                    style: KLatoTextStyle,
                                                  ),
                                                  subtitle: Text(
                                                    req.vehiclesDetail[index]
                                                            .model ??
                                                        "",
                                                    style:
                                                        KLatoRegularTextStyle,
                                                  ),
                                                  trailing: index == 0
                                                      ? Text(
                                                          '\$${req.totalEstimation}',
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .greenAccent),
                                                        )
                                                      : null,
                                                );
                                              },
                                            ),
                                            ListTile(
                                                title: Text(
                                                  req.title ?? "",
                                                  style: KAppTitleTextStyle,
                                                ),
                                                subtitle: Text(
                                                    req.note.length > 20
                                                        ? '${req.note.substring(0, 20)}...'
                                                        : req.note,
                                                    style: KHintTextStyle)),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                }),
        ),
      ),
      bottomSheet: title != -1
          ? ReSchedulePage(
              estimateDetail: estimateDetail,
              title: titles[title],
              onClickNext: onClickNextButton,
              onClickBack: onClickBackButton,
              hideDetail: hideDetail,
              refreshEstimate: refreshEstimate,
              onClickClose: onClickClose)
          : null,
    );
  }
}
