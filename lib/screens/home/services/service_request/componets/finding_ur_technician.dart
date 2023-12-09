import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda/models/add_service_request_model.dart';
import 'package:panda/provider/service_request_provider.dart';
import 'package:panda/screens/home/services/browse/components/mechanics_profile.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../../commonComponents/skeletal/custom_card_skeletal.dart';
import '../../../../../provider/nearby_provider.dart';
import '../../../../../util/ui_constant.dart';

class FindingYourTechnician extends StatefulWidget {
  final AddServiceRequestModel addServiceRequestModel;
  const FindingYourTechnician({Key? key, required this.addServiceRequestModel})
      : super(key: key);

  @override
  State<FindingYourTechnician> createState() => _FindingYourTechnicianState();
}

class _FindingYourTechnicianState extends State<FindingYourTechnician> {
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    refreshNearByTech();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NearByProvider>().nearBy(
          context,
          widget.addServiceRequestModel.latitude,
          widget.addServiceRequestModel.longitude,
          backToHome,
          false);
    });
  }

  void cancelServiceRequest() {
    context
        .read<ServiceRequestProvider>()
        .cancelServiceRequest(context, widget.addServiceRequestModel.serviceId);
  }

  void backToHome() {
    context.read<ServiceRequestProvider>().noNearBy(context);
  }

  void refreshNearByTech() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NearByProvider>().nearBy(
          context,
          widget.addServiceRequestModel.latitude,
          widget.addServiceRequestModel.longitude,
          backToHome,
          false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: const WaterDropHeader(),
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: const EdgeInsets.only(top: 40),
            child: Column(
              children: [
                Consumer<NearByProvider>(builder: (context, value, child) {
                  return value.isLoading
                      ? ListView.builder(
                          itemCount: 7,
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return const CustomCardSkeletal();
                          })
                      : Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 25,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Nearby technicians",
                                      style: KAppTitleTextStyle,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              itemCount: value.nearby.length,
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                final req = value.nearby[index];

                                return MechanicsProfile(
                                    mechanicProfile: req,
                                    sendServiceRequest: (value) async {
                                      await context
                                          .read<ServiceRequestProvider>()
                                          .updateServiceRequestByStatus(
                                              context, value);

                                      // ignore: use_build_context_synchronously
                                      Navigator.pushReplacementNamed(
                                          context, "/home",
                                          arguments:
                                              widget.addServiceRequestModel);
                                    });
                              },
                            ),
                          ],
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
