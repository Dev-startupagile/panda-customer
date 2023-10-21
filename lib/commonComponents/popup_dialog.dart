import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import '../util/ui_constant.dart';

Future showPopupDialog(context,text, height,width,yesCancel) {
  return showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      content: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: KLatoTextStyle,),
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
                    child:  Text(
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
                    child:  Text(
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

Future showPopupDetailDialog(context, height,width,text) {
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
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close,color: Colors.red,)
                )
              ],
            ),

            Text("Note Detail", style: KLatoTextStyle,),

            SizedBox(height: height * 0.02),

            Text(text,
                style: KLatoRegularTextStyle),

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
