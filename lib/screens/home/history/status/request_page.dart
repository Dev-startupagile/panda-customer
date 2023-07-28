import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda/provider/service_request_provider.dart';
import 'package:panda/screens/home/history/historyComponent/history_list_tile.dart';
import 'package:panda/screens/home/history/status/request_detail.dart';
import 'package:panda/util/constants.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../commonComponents/skeletal/custom_card_skeletal.dart';
import '../../../../function/launcher.dart';
import '../../../../models/request_status_model.dart';
import '../../../../provider/notification_provider.dart';
import '../../../../util/ui_constant.dart';

class RequestPage extends StatefulWidget {
  String status;
  bool isFromNearBy;
  RequestPage({required this.status, required this.isFromNearBy, Key? key})
      : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isDetail = false;
  Datum? requestDetail;
  String _activeTab = "diagnostic";

  late TabController _tabFamController;

  @override
  void initState() {
    super.initState();
    if (widget.isFromNearBy) {
      refreshRequest();
    } else {
      fetchRequest(widget.status);
    }
    _tabFamController = TabController(vsync: this, length: 2);
    _tabFamController.addListener(() {
      setState(() {
        if (_tabFamController.index == 0) {
          _activeTab = "diagnostic";
        } else if (_tabFamController.index == 1) {
          _activeTab = "non-diagnostic";
        }
      });
    });
  }

  void onClickDiagnostic() {
    fetchRequest(completedDiagnosticConst);
  }

  void onClickComplete() {
    fetchRequest(completedAllConst);
  }

  void fetchRequest(statusType) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ServiceRequestProvider>()
          .getServiceRequestByStatus(context, statusType);
    });

    if (statusType == pendingConst) {
      context.read<NotificationProvider>().updatePendingBadge();
    } else if (statusType == acceptedConst) {
      context.read<NotificationProvider>().updateAcceptedBadge();
    } else if (statusType == canceledConst) {
      context.read<NotificationProvider>().updateCanceledBadge();
    } else if (statusType == completedDiagnosticConst) {
      context.read<NotificationProvider>().updateCompletedBadge();
    }
  }

  void refreshRequest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ServiceRequestProvider>()
          .getServiceRequestByStatus(context, widget.status);
    });
  }

  void actionMethod(Datum req) {
    setState(() {
      isDetail = true;
      requestDetail = req;
    });
  }

  void requestCanceledServiceRequest() {
    setState(() {
      isDetail = false;
    });
    context
        .read<ServiceRequestProvider>()
        .reRequestCanceledService(context, requestDetail!, requestDetail?.id);
  }

  void cancelServiceRequest() {
    setState(() {
      isDetail = false;
    });
    context
        .read<ServiceRequestProvider>()
        .cancelServiceRequest(context, requestDetail?.id);
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshRequest();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SmartRefresher(
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
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: widget.status == completedDiagnosticConst,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _tabFamController.animateTo(0);
                      onClickDiagnostic();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: width * 0.02, horizontal: width * 0.05),
                      decoration: BoxDecoration(
                          border: _activeTab == "diagnostic"
                              ? const Border(
                                  bottom: BorderSide(
                                      color: kPrimaryColor, width: 3))
                              : null),
                      child: Text(
                        'Diagnostic',
                        style: _activeTab == "diagnostic"
                            ? KLoginActiveMenuTextStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor)
                            : KLoginInactiveMenuTextStyle,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _tabFamController.animateTo(1);
                      onClickComplete();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: width * 0.02, horizontal: width * 0.05),
                      decoration: BoxDecoration(
                          border: _activeTab == "non-diagnostic"
                              ? const Border(
                                  bottom: BorderSide(
                                      color: kPrimaryColor, width: 3))
                              : null),
                      child: Text(
                        'Completed',
                        style: _activeTab == "non-diagnostic"
                            ? KLoginActiveMenuTextStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor)
                            : KLoginInactiveMenuTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isDetail
                ? Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isDetail = false;
                              });
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                        Visibility(
                          visible: widget.status == completedConst,
                          child: PopupMenuButton(itemBuilder: (context) {
                            return [
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Text("Report"),
                              ),
                            ];
                          }, onSelected: (value) {
                            if (value == 0) {
                              launchEmail();
                            }
                          }),
                        ),
                      ],
                    ),
                    requestProfile(requestDetail!, cancelServiceRequest,
                        requestCanceledServiceRequest, scrollController)
                  ])
                : Consumer<ServiceRequestProvider>(
                    builder: (context, value, child) {
                    return value.requests.isEmpty && value.isLoaded
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 45,
                              ),
                              EmptyWidget(
                                image: "assets/logo.png",
                                title: widget.status == pendingConst
                                    ? 'No Pending Request'
                                    : widget.status == acceptedConst
                                        ? 'No Accepted Request'
                                        : widget.status == canceledConst
                                            ? 'No Canceled Request'
                                            : 'No Completed Request',
                                // subTitle: 'No Request available yet',
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
                                controller: scrollController,
                                itemBuilder: (context, index) {
                                  return const CustomCardSkeletal();
                                })
                            : ListView.builder(
                                itemCount: value.requests.length,
                                shrinkWrap: true,
                                controller: scrollController,
                                itemBuilder: (context, index) {
                                  final req = value.requests[index];

                                  return historyListTile(
                                      widget.status,
                                      req.description?.title ?? "",
                                      req.description?.note,
                                      req.schedule?.date ?? "",
                                      actionMethod,
                                      req,
                                      req.requestStatus);
                                });
                  }),
          ],
        ),
      ),
    );
  }
}
