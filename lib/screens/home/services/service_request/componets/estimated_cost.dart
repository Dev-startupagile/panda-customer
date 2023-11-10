// import 'package:flutter/material.dart';
// import 'package:panda/commonComponents/buttons/main_button.dart';
// import 'package:panda/provider/estimate_provider.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../../util/ui_constant.dart';
//
// class EstimatedCost extends StatelessWidget {
//   final Function requestService;
//   const EstimatedCost({ required this.requestService, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Consumer<EstimateProvider>(
//         builder: (context,value,child) {
//           return Column(
//
//             children: [
//               SizedBox(height: height*0.1),
//                 value.estimates[].
//               const Center(
//                 child: Text(
//                   "Estimated costes are ased on current rates in your area. If everything looks good, smash the button below to create your service request.",
//                   style: TextStyle(color: Colors.black54),
//                 ),
//               ),
//               const SizedBox(
//                 height: 60,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children:  [
//                   const Text(
//                     "up to",
//                     style:
//                     TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   const Text(
//                     "\$65 ",
//                     style: TextStyle(
//                         fontSize: 35,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.greenAccent),
//                   ),
//                   Text(
//                       " diagnostic fee",
//                       style: KHintTextStyle
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//
//               mainButton('CONFIRM SERVICE REQUEST', requestService,kPrimaryColor),
//
//               SizedBox(
//                 width: double.infinity,
//                 child: TextButton(
//                   onPressed: () {
//                     // Navigator.pushNamed(
//                     //     context, CustomerServiceRSPendingTab.routeName);
//                   },
//                   child: const Text(
//                     'IMPORTANT SERVICE INFORMATION',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }
//       ),
//     );
//   }
// }
