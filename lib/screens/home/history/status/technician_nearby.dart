import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda/provider/service_request_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../commonComponents/skeletal/custom_card_skeletal.dart';
import '../../../../provider/nearby_provider.dart';
import '../../../../util/ui_constant.dart';
import '../../services/browse/components/mechanics_profile.dart';

class NearByTechnician extends StatefulWidget {
  double latitude;
  double longitude;
  NearByTechnician({required this.latitude, required this.longitude, Key? key})
      : super(key: key);

  @override
  State<NearByTechnician> createState() => _NearByTechnicianState();
}

class _NearByTechnicianState extends State<NearByTechnician>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  void fetchRequest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NearByProvider>().nearBy(
          context, widget.latitude, widget.longitude, backToHome, false);
    });
  }

  backToHome() {
    Navigator.pop(context);
  }

  void sendServiceRequest(String id, String requestId) async {
    await context
        .read<ServiceRequestProvider>()
        .updateServiceRequestByStatus(context, id, requestId);
    Navigator.pop(context);
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    fetchRequest();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Nearby technicians',
              style: KProfilePicAppBarTextStyle,
            ),
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: KPColor,
                )),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<NearByProvider>(builder: (context, value, child) {
                  return value.isLoading
                      ? ListView.builder(
                          itemCount: 7,
                          shrinkWrap: true,
                          controller: scrollController,
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
                            ListView.builder(
                              itemCount: value.nearby.length,
                              shrinkWrap: true,
                              controller: scrollController,
                              itemBuilder: (context, index) {
                                final req = value.nearby[index];

                                return MechanicsProfile(
                                    mechanicProfile: req,
                                    sendServiceRequest: sendServiceRequest);
                              },
                            ),
                          ],
                        );
                }),
              ],
            ),
          ),
        ));
  }
}
