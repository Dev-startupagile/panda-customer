import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:panda/models/review_model.dart';
import 'package:panda/screens/home/services/rating.dart';

import '../util/ui_constant.dart';

Future showPopupDialog(context, text, height, width, yesCancel) {
  return showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      content: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: KLatoTextStyle,
            ),
            SizedBox(height: height * 0.02),
            Text('Are you sure you want to continue?',
                style: KLatoRegularTextStyle),
            SizedBox(height: height * 0.02),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    yesCancel();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kPrimaryColor),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.04, horizontal: width * 0.06),
                    child: Text(
                      'Yes, $text',
                      style: KOnBoardGetStartedTextStyle,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.04, horizontal: width * 0.06),
                    child: Text(
                      'No, close window',
                      style: KNativeTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future showPopupDetailDialog(context, height, width, text) {
  return showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      content: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ))
              ],
            ),

            Text(
              "Note Detail",
              style: KLatoTextStyle,
            ),

            SizedBox(height: height * 0.02),

            Text(text, style: KLatoRegularTextStyle),

            SizedBox(height: height * 0.02),

            // ElevatedButton(
            //   onPressed: () {
            //   },
            //   style: ButtonStyle(
            //     backgroundColor:
            //     MaterialStateProperty.all<Color>(Colors.white),
            //   ),
            //   child: Container(
            //     padding: EdgeInsets.symmetric(
            //         vertical: width * 0.04, horizontal: width * 0.06),
            //     child:  Text(
            //       'close window',
            //       style: KNativeTextStyle,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ),
  );
}

void showConfirmationDialog(
    BuildContext context, String title, String msg, Function() callback) {
  showDialog(
    context: context,
    builder: (BuildContext context2) {
      return AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              // Close the dialog first
              Navigator.pop(context);
              callback();
            },
          ),
        ],
      );
    },
  );
}

void showInfoDialog(BuildContext context, String msg, Function() callback) {
  showDialog(
    context: context,
    builder: (BuildContext context2) {
      return AlertDialog(
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              // Close the dialog first
              Navigator.pop(context);
              callback();
            },
          ),
        ],
      );
    },
  );
}

void showReviewPopup(BuildContext context, String name, String to,
    String? requestId, Function(ReviewModel) callback) {
  showDialog(
    barrierDismissible: true,
    context: context,
    useSafeArea: true,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.1),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Container()),
                Material(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Column(children: [
                      const SizedBox(height: 5),
                      const Text(
                        "Review!",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 32),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Please review $name",
                        style: const TextStyle(color: Color(0xffC0BFBD)),
                      ),
                      const SizedBox(height: 5),
                      RatingWidget(
                        requestId: requestId,
                        to: to,
                        callback: (review) {
                          showConfirmationDialog(context, "Thank you!",
                              "Successfully reviewed $name", () {
                            // Navigator.pop(context);
                            callback(review);
                          });
                        },
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showPopUpDialogBox(
    BuildContext context,
    String title,
    String message,
    String negativeButton,
    String positiveButton,
    Function negativeCallBack,
    Function positiveCallBack) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              title,
            ),
            content: Text(message),
            //buttons?
            actions: <Widget>[
              TextButton(
                child: Text(negativeButton),
                onPressed: () {
                  negativeCallBack();
                }, //closes popup
              ),
              TextButton(
                child: Text(positiveButton),
                onPressed: () {
                  positiveCallBack();
                }, //closes popup
              )
            ],
          ));
}
