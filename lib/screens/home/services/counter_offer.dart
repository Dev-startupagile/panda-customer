import 'package:flutter/material.dart';
import 'package:panda/commonComponents/loading_dialog.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:provider/provider.dart';
import '../../../commonComponents/buttons/main_button.dart';
import '../../../commonComponents/skeletal/custom_card_skeletal.dart';
import '../../../provider/estimate_provider.dart';
import '../../../provider/notification_provider.dart';
import '../../../util/ui_constant.dart';
import '../history/historyComponent/history_list_tile.dart';

class CounterOffer extends StatefulWidget {
  String requestId;
  CounterOffer({Key? key, required this.requestId}) : super(key: key);

  @override
  State<CounterOffer> createState() => _CounterOfferState();
}

class _CounterOfferState extends State<CounterOffer> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          context
              .read<EstimateProvider>()
              .getEstimateById(context, widget.requestId)
        });
  }

  final dialog = DialogHandler();

  void _callback(context, String msg) {
    dialog.closeLoadingDialog(context);
    displaySuccessSnackBar(context, msg);
    // notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    void decline() async {
      print(widget.requestId);
      await context.read<EstimateProvider>().declineEstimate(
          context, context.read<EstimateProvider>().estimateDetail[0].id);
      context.read<NotificationProvider>().updateCounterOffer();
    }

    void accept() async {
      await EstimateProvider().approveEstimate(
          context.read<EstimateProvider>().estimateDetail[0].id,
          (msg) => _callback(context, msg));
      context.read<NotificationProvider>().updateCounterOffer();
    }

    return SizedBox(
        // height: 400,
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Card(
            child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: const Text(
              "Offer Description",
              style: KAppTitleTextStyle,
            ),
            subtitle: Row(
              children: [
                const Icon(
                  Icons.circle,
                  color: kPrimaryColorSecondary,
                ),
                Text(
                  "Technician Sent You New Offer",
                  style: KLatoRegularTextStyle,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Consumer<EstimateProvider>(builder: (context, value, child) {
            return value.isLoading
                ? ListView.builder(
                    itemCount: 7,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return const CustomCardSkeletal();
                    })
                : ListView.builder(
                    itemCount: 1,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      final req = value.estimateDetail[index];
                      return Column(
                        children: [
                          const Center(
                            child:
                                Text("Service Type", style: KAppTitleTextStyle),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          Center(
                            child: Text(req.title ?? "", style: KHintTextStyle),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Center(
                            child: Text("Offer Description",
                                style: KAppTitleTextStyle),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                    child: Text(req.note ?? "",
                                        style: KHintTextStyle)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text("Vehicle Information",
                              style: KAppTitleTextStyle),

                          const SizedBox(
                            height: 20,
                          ),

                          // ListView.builder(
                          //     itemCount: value.estimateDetail?.vehiclesDetail.length,
                          //     shrinkWrap: true,
                          //     controller: _scrollController,
                          //     itemBuilder: (context,index){
                          //       return
                          //         Column(
                          //           children: [
                          //             vehicleAvatar(true, value.estimateDetail?.vehiclesDetail[index].image, null),
                          //             customRequestList("Model", value.estimateDetail?.vehiclesDetail[index].model),
                          //             customRequestList("Plate Number", value.estimateDetail?.vehiclesDetail[index].plateNumber.toString()),
                          //             customRequestList("Transmission", value.estimateDetail?.vehiclesDetail[index].transmission),
                          //             customRequestList("Make", value.estimateDetail?.vehiclesDetail[index].make.toString()),
                          //             customRequestList("Description", value.estimateDetail?.vehiclesDetail[index].description),
                          //
                          //           ],
                          //         );
                          //     }
                          // ),

                          const SizedBox(
                            height: 20,
                          ),

                          const Text("Items list" ?? "",
                              style: KAppTitleTextStyle),
                          const SizedBox(
                            height: 20,
                          ),

                          Container(
                              height: 35,
                              decoration:
                                  BoxDecoration(color: Colors.grey[500]),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "Title",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text("Price",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              )),
                          ListView.builder(
                              itemCount: req.items.length,
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: 1))),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(children: [
                                                  Text(
                                                      req.items[index].title ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                ]),
                                                Row(children: [
                                                  Text(
                                                      "\$${req.items[index].price}",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                ]),
                                              ])),
                                    ),
                                  ],
                                );
                                // customRequestList(estimateDetail.items[index].title ?? "", "\$${estimateDetail.items[index].price}" ?? "");
                              }),

                          const SizedBox(
                            height: 10,
                          ),

                          customRequestList("Tax", '\$${req.vat}'),

                          customRequestList(
                              "Labour Estimation", '\$${req.totalEstimation}'),

                          Visibility(
                              visible: req.discount != 0,
                              child: customRequestList(
                                  "Discount", '\$${req.discount ?? 0}')),

                          const SizedBox(
                            height: 10,
                          ),

                          customRequestList("Technician Email", req.sender),

                          const SizedBox(
                            height: 20,
                          ),

                          mainButton("ACCEPT", accept, kPrimaryColor),
                          mainButton("DECLINE", decline, kErrorColor),
                          // mainButton("RE-REQUEST", rerequest, kPrimaryColor)
                        ],
                      );
                    });
          }),
        ])),
      ),
    ));
  }
}
