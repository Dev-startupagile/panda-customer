import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../function/launcher.dart';
import '../../../../models/request_status_model.dart';
import '../../../../util/constants.dart';
import '../../../../util/ui_constant.dart';

Widget historyListTile(status, titleText, subtitleText, date, actionMethod,
        Datum req, reqStatus) =>
    InkWell(
      onTap: () {
        actionMethod(req);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: req.isScheduled ?? false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.grey),
                    child: Text(
                      "Scheduled",
                      style: KLatoTextStyle,
                    ),
                  ),
                )),
            ListTile(
              leading: Image.asset(
                "assets/mechanic.png",
              ),
              title: Text(titleText),
              subtitle: Text(subtitleText),
              trailing: Column(
                children: [
                  Visibility(
                      visible: status != completedConst,
                      child: Text(
                        DateFormat('MM/dd/yyyy').format(req.createdAt!),
                        style: KLatoTextStyle,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: status == completedConst,
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
                  Visibility(
                      visible: status == acceptedConst,
                      child: Text(
                        reqStatus,
                        style: const TextStyle(color: kPrimaryColor),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );

Widget customRequestList(title, subtitle) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Text(
              title,
              style: KLatoTextStyle,
            ),
          ),
          Expanded(
            child: Text(
              subtitle ?? "",
              style: KLatoRegularTextStyle,
            ),
          ),
        ],
      ),
    );
