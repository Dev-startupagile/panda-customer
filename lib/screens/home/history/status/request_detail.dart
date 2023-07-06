import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:panda/screens/home/history/historyComponent/history_list_tile.dart';

import '../../../../commonComponents/buttons/main_button.dart';
import '../../../../commonComponents/profile_avatar.dart';
import '../../../../function/substring.dart';
import '../../../../models/request_status_model.dart';
import '../../../../util/constants.dart';
import '../../../../util/ui_constant.dart';

Widget requestProfile(Datum requestDetail,cancelServiceRequest,rerequestServiceRequest,scrollController)=> Padding(
  padding: const EdgeInsets.all(0.0),
  child: Card(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),

          Center(
            child: Image.asset(
              "lib/assets/mechanic.png",
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          const Center(
            child: Text(
                "Service Detail",
                style:KAppTitleTextStyle
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          customRequestList("Service Type", requestDetail.description?.title),

          customRequestList("Service Description", requestDetail.description?.note ?? ""),

          const SizedBox(
            height: 30,
          ),

          Visibility(
            visible: requestDetail.description?.attachments.isNotEmpty ?? false,
              child: Column(
                children: [
                  const Text(
                      "Attachments",
                      style:KAppBodyTextStyle
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 100,

                    child: ListView.builder(
                        itemCount: requestDetail.description?.attachments.length,
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        controller: scrollController,
                        itemBuilder: (context,index){
                          return
                            Row(
                              children: [
                                vehicleAvatar(false, requestDetail.description?.attachments[index], null),
                              ],
                            );
                        }
                    ),
                  ),
                ],
              )
          ),

          const SizedBox(
            height: 20,
          ),
          customRequestList("Title", requestDetail.serviceDetail?.title),

          customRequestList("Description", requestDetail.serviceDetail?.description),

          customRequestList("Location", requestDetail.serviceLocation?.name),

          customRequestList("Created At",  DateFormat('MM/dd/yyyy hh:mm a').format(requestDetail.schedule?.date ?? DateTime.now()).toString()),

          const SizedBox(
            height: 20,
          ),

          Visibility(
              visible: requestDetail.requestStatus != pendingConst.toUpperCase() ,
              child: Column(
                children: [
                  const Center(
                    child: Text(
                        "Technician Detail",
                        style:KAppTitleTextStyle
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  customRequestList("Full Name", requestDetail. technicianInfo?.fullName),
                  customRequestList("Email", requestDetail.technicianId ?? ""),
                  customRequestList("State", requestDetail.technicianInfo?.state),
                  customRequestList("Zip code", requestDetail.technicianInfo?.zipCode.toString()),
                  customRequestList("Phone Number", requestDetail.technicianInfo?.phoneNumber),

                  const SizedBox(
                    height: 20,
                  ),

                  Visibility(
                    visible: requestDetail.price?.hourlyFee != null,
                    child: Column(
                      children: [
                         Center(
                          child: Visibility(
                            visible:requestDetail.requestStatus != canceledConst,
                            child: const Text(
                                "Price Detail",
                                style:KAppTitleTextStyle
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        Visibility(
                          visible: requestDetail.requestStatus == acceptedConst.toUpperCase() || requestDetail.requestStatus == "ARRIVED",
                            child:
                            customRequestList("Your Diagnostic Fee", requestDetail.price?.hourlyFee.toString() )
                        ),

                        Visibility(
                            visible: requestDetail.requestStatus == completedAllConst.toUpperCase(),
                            child:
                            customRequestList("Completed Diagnostic Fee", adder(requestDetail.price?.diagnosticFee ?? 0, requestDetail.price?.hourlyFee ?? 0) ),
                        ),

                      ],
                    ),
                  )

                ],
              )
          ),

          const SizedBox(
            height: 20,
          ),
          const Text(
              "Vehicle Information",
              style:KAppTitleTextStyle
          ),

          const SizedBox(
            height: 20,
          ),

          ListView.builder(
              itemCount: requestDetail.vehiclesDetail.length,
              shrinkWrap: true,
              controller: scrollController,
              itemBuilder: (context,index){
                return
                  Column(
                    children: [
                      vehicleAvatar(true, requestDetail.vehiclesDetail[index].image, null),
                      customRequestList("Model", requestDetail.vehiclesDetail[index].model),
                      customRequestList("Plate Number", requestDetail.vehiclesDetail[index].plateNumber.toString()),
                      customRequestList("Transmission", requestDetail.vehiclesDetail[index].transmission),
                      customRequestList("Make", requestDetail.vehiclesDetail[index].make.toString()),
                      customRequestList("Description", requestDetail.vehiclesDetail[index].description),

                    ],
                  );
              }
          ),

          const SizedBox(
            height: 20,
          ),
          Visibility(
              visible: requestDetail.requestStatus == pendingConst.toUpperCase(),
              child: mainButton("Cancel Request", cancelServiceRequest, Colors.red)
          ),
          Visibility(
              visible: requestDetail.requestStatus == canceledConst.toUpperCase(),
              child: mainButton("Re Request", rerequestServiceRequest, kPrimaryColor)
          )
        ],

      )
  ),
);