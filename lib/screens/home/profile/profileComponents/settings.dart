import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../commonComponents/popup_dialog.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../util/ui_constant.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    void yesDelete(){
      context.read<ProfileProvider>().deleteAccount(context);
    }

    void deleteAccount(){
      showPopupDialog(context, "Delete Account", height, width, yesDelete);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Center(
            //   child:TextButton(
            //     onPressed: () {
            //
            //     },
            //     child: const Text(
            //       'Verify Email',
            //       style: KProfilePicAppBarTextStyle,
            //     ),
            //   ),
            // ),

            Center(
              child:TextButton(
                onPressed: () {
                  deleteAccount();
                },
                child: const Text(
                  'Delete Account',
                  style: KDangerTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
      );
  }
}
