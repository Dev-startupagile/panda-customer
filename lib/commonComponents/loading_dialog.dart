import 'package:flutter/material.dart';
import '../util/ui_constant.dart';

class DialogHandler {
  void openLoadingDialog(context) async {
    // show the loading dialog
    return showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return const Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
  }

  void closeLoadingDialog(context) {
    Navigator.of(context).pop();
  }
}
