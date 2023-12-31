import 'package:flutter/material.dart';

import '../../../../util/ui_constant.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy and policy',
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
          ),
        ),
      ),
      body: Container(
        width: width,
        padding: EdgeInsets.symmetric(
            vertical: width * 0.05, horizontal: width * 0.05),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Text("Introductions"),
            SizedBox(
              height: 10,
            ),
            Text(
                "At Panda, we are committed to protecting the privacy of our users. This Privacy Policy outlines the information we collect and how we use it to provide you with the best possible experience using our app."),
            SizedBox(
              height: 10,
            ),
            Text("Sharing of Information"),
            SizedBox(
              height: 10,
            ),
            Text(
                "Panda will not sell or share your personal information with any third parties for any purpose other than providing you with the services you request. We may share your information with our service providers who assist us in providing you with the services you request, such as payment processors and marketing agencies. We take commercially reasonable steps to ensure that these service providers maintain the privacy and security of your information."),
            SizedBox(
              height: 10,
            ),
            Text("Data Retention"),
            SizedBox(
              height: 10,
            ),
            Text(
                "Panda will retain your personal information for as long as necessary to provide you with the services you request. We may also retain your information for a period of time thereafter for the purpose of complying with legal obligations, resolving disputes, and enforcing our agreements."),
            SizedBox(
              height: 10,
            ),
            Text("Security"),
            SizedBox(
              height: 10,
            ),
            Text(
                "Panda takes commercially reasonable steps to protect the security of your personal information. However, no data transmission over the internet or storage of information can be 100% secure, and we cannot guarantee the security of your information. "),
            SizedBox(
              height: 10,
            ),
            Text("Changes to this Privacy Policy"),
            SizedBox(
              height: 10,
            ),
            Text(
                "Panda may revise this Privacy Policy from time to time. The most current version of the Privacy Policy will govern our use of your information and will be available on our app. If we make any material changes to this Privacy Policy, we will notify you by posting a notice on our app or by sending you an email."),
            SizedBox(
              height: 10,
            ),
            Text("Contact Information"),
            SizedBox(
              height: 10,
            ),
            Text(
                "If you have any questions or concerns about this Privacy Policy, please contact us at information@panda-mars.com. "),
            SizedBox(
              height: 10,
            ),
            Text("Acceptance of Terms"),
            SizedBox(
              height: 10,
            ),
            Text(
                "By using our app, you agree to the terms of this Privacy Policy and our User Agreement. If you do not agree with these terms, please do not use our app."),
            SizedBox(
              height: 10,
            ),
          ]),
        )),
      ),
    );
  }
}
