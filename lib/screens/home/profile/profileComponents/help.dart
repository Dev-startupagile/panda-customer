import 'package:flutter/material.dart';

import '../../../../util/ui_constant.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Help',
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text("Panda Help Section",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Panda Help Section Welcome to the Panda Help Section. Our goal is to provide you with the best mobile mechanic services through our app. Here are answers to some frequently asked questions that may help you better understand and use our platform.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("How do I find a mobile mechanic near me?",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                            "1. You can easily find a mobile mechanic near you by using the “Find a Mechanic” feature in the app. Simply input your location, select the type of service you need, and browse through the list of available technicians in your area. You can also view the hourly rates and read reviews before making your selection.",
                            style: TextStyle(
                                color: Color.fromARGB(255, 104, 101, 101))),
                        SizedBox(height: 5),
                        Text(
                          "How do I book an appointment with a mobile mechanic?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                            "2. Once you have selected a mobile mechanic, you can book an appointment through the app by selecting a date and time that works best for you. You will receive a confirmation email with all the details of your appointment, including the name and contact information of your technician.",
                            style: TextStyle(
                                color: Color.fromARGB(255, 104, 101, 101))),
                        Text(
                          "How do I pay for services through the app?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                            "3. After the technician has completed their work, they will create an estimate for you to review. If you approve, you can then pay directly through our secure payment portal. We use Stripe to process payments, ensuring that all transactions are safe and secure.",
                            style: TextStyle(
                                color: Color.fromARGB(255, 104, 101, 101))),
                        Text(
                          "How can I rate and review my experience with a mobile mechanic?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                            "4. Once you have completed your appointment and paid for services, you will have the opportunity to rate and review your experience with the mobile mechanic. Your feedback helps us maintain the highest quality of service and helps other customers find the best technicians for their needs",
                            style: TextStyle(
                                color: Color.fromARGB(255, 104, 101, 101))),
                        Text(
                          "What should I do if I have a problem with my appointment?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                            "5. If you have a problem with your appointment or experience any issues with the app, please contact us at information@panda-mars.com. Our customer support team will work with you to resolve any issues and ensure that your experience with Panda is a positive one",
                            style: TextStyle(
                                color: Color.fromARGB(255, 104, 101, 101))),
                        SizedBox(height: 5),
                        Text(
                            "We hope this Help Section has been helpful. If you need further assistance, please do not hesitate to reach out to us at information@panda-mars.com. Thank you for choosing Panda for your mobile mechanic needs",
                            style: TextStyle(
                                color: Color.fromARGB(255, 104, 101, 101)))
                      ]))),
        ));
  }
}
