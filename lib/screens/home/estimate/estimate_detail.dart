import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panda/commonComponents/loading_dialog.dart';
import 'package:panda/commonComponents/popup_dialog.dart';
import 'package:panda/commonComponents/profile_avatar.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:panda/screens/home/history/historyComponent/history_list_tile.dart';
import 'dart:core';

import '../../../../commonComponents/buttons/main_button.dart';
import '../../../../util/ui_constant.dart';
import '../../../models/estimate_model.dart';
import '../../../provider/estimate_provider.dart';

class EstimateDetail extends StatelessWidget {
  Datum estimateDetail;
  Function hideDetail;
  Function refreshPage;
  Function estimationSetter;
  final ScrollController _scrollController = ScrollController();

  EstimateDetail(
      {required this.estimationSetter,
      required this.refreshPage,
      required this.hideDetail,
      required this.estimateDetail,
      Key? key})
      : super(key: key);
  final dialog = DialogHandler();

  void _payAndAccept(BuildContext context) async {
    dialog.openLoadingDialog(context);

    await EstimateProvider()
        .approveEstimate(estimateDetail.id, (msg) => _callback(context, msg));
    hideDetail();
    refreshPage();
  }

  void _callback(BuildContext context, String msg) {
    Navigator.of(context).pop();

    displaySuccessSnackBar(context, msg);
    // notifyListeners();
  }

  void decline(context) async {
    await context
        .read<EstimateProvider>()
        .declineEstimate(context, estimateDetail.id);
    hideDetail();
    refreshPage();
  }

  void accept(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        return AlertDialog(
          title: const Text("Payment Confiramtion"),
          content: Text(
              "You're about to pay ${estimateDetail.totalEstimation} USD to ${estimateDetail.sender}"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                // Close the dialog first
                Navigator.of(context).pop();
                _payAndAccept(context);
              },
            ),
            TextButton(
                child: const Text("Cancle"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  void rerequest() {
    estimationSetter(estimateDetail);
    refreshPage();
  }

  void showNoteDetail(String text, context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    showPopupDetailDialog(context, height, width, text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Image.asset(
              "assets/mechanic.png",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text("Service Type", style: KAppTitleTextStyle),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(estimateDetail.title ?? "", style: KHintTextStyle),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text("Offer Description", style: KAppTitleTextStyle),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                      estimateDetail.note.length > 20
                          ? '${estimateDetail.note.substring(0, 20)}...'
                          : estimateDetail.note,
                      style: KHintTextStyle)),
              TextButton(
                  onPressed: () {
                    showNoteDetail(estimateDetail.note, context);
                  },
                  child: const Text("More"))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Vehicle Information", style: KAppTitleTextStyle),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
              itemCount: estimateDetail.vehiclesDetail.length,
              shrinkWrap: true,
              controller: _scrollController,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    vehicleAvatar(
                        true, estimateDetail.vehiclesDetail[index].image, null),
                    customRequestList(
                        "Model", estimateDetail.vehiclesDetail[index].model),
                    customRequestList(
                        "Plate Number",
                        estimateDetail.vehiclesDetail[index].plateNumber
                            .toString()),
                    customRequestList("Transmission",
                        estimateDetail.vehiclesDetail[index].transmission),
                    customRequestList("Make",
                        estimateDetail.vehiclesDetail[index].make.toString()),
                    customRequestList("Description",
                        estimateDetail.vehiclesDetail[index].description),
                  ],
                );
              }),
          const SizedBox(
            height: 20,
          ),
          const Text("Items list" ?? "", style: KAppTitleTextStyle),
          const SizedBox(
            height: 20,
          ),
          Container(
              height: 35,
              decoration: BoxDecoration(color: Colors.grey[500]),
              width: MediaQuery.of(context).size.width,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Title",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("Price", style: TextStyle(color: Colors.white)),
                  ),
                ],
              )),
          ListView.builder(
              itemCount: estimateDetail.items.length,
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
                                      color: Colors.grey.shade400, width: 1))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Text(estimateDetail.items[index].title,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal)),
                                ]),
                                Row(children: [
                                  Text(
                                      "\$${estimateDetail.items[index].price}.00",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal)),
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
          customRequestList("Tax", '%${estimateDetail.vat}'),
          customRequestList(
              "Labour Estimation", '\$${estimateDetail.totalEstimation}'),
          Visibility(
              visible: estimateDetail.discount != 0,
              child: customRequestList(
                  "Discount", '\$${estimateDetail.discount ?? 0}')),
          const SizedBox(
            height: 10,
          ),
          customRequestList("Technician Email", estimateDetail.sender),
          customRequestList(
              "Created At",
              DateFormat('MM/dd/yyyy hh:mm a')
                  .format(estimateDetail.createdAt)
                  .toString()),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Visibility(
                  visible: !(estimateDetail.isApproved) &&
                      !(estimateDetail.isRejected),
                  child: mainButton(
                      "ACCEPT", () => accept(context), kPrimaryColor)),
              const SizedBox(
                width: 15,
              ),
              Visibility(
                  visible: !(estimateDetail.isApproved) &&
                      !(estimateDetail.isRejected),
                  child: mainButton(
                      "DECLINE", () => decline(context), kErrorColor)),
              const SizedBox(
                width: 15,
              ),
              Visibility(
                  visible: (estimateDetail.isRejected),
                  child: mainButton("RE-REQUEST", rerequest, kPrimaryColor)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      )),
    );
  }
}
