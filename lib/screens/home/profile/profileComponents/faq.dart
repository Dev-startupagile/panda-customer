import 'package:flutter/material.dart';

import '../../../../util/ui_constant.dart';

class Faq extends StatelessWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Faq',
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
      body: SingleChildScrollView(
        child: SizedBox(
          // height: height,
          width: width,
          child: Column(
            children: [
              // SizedBox(
              //   // height: height * 0.25,
              //   width: width,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SizedBox(
              //         child: Image.asset(
              //           "assets/logo.png",
              //           height: 200,
              //           fit: BoxFit.contain,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text("Frequently asked questions",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "What is ThePanda app?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    "1. Panda is a mobile app that connects customers to automotive service professionals (also known as technicians) for all your mobile automotive service needs",
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 104, 101, 101))),
                                SizedBox(height: 5),
                                Text(
                                  "How do I use the app to schedule a service?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                    "2. You can use the app to locate a technician near you, select your service, and choose a time that works best for you. The app will send a professional to your location to diagnose your vehicle and create an estimate.",
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 104, 101, 101))),
                                Text(
                                  "Can I pay for the service through the app?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                    "3. Yes, you can pay for the service directly through a secured portal after the work is completed.",
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 104, 101, 101))),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Can I leave a review for the technician?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                    "4. Yes, you can leave a rating and review for the technician after the service is completed",
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 104, 101, 101))),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Is the app free for customers to use?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                    "5. Yes, the app is free for customers to use.",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 104, 101, 101)))
                              ]))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
