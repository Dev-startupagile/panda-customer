import 'package:flutter/material.dart';
import 'package:panda/commonComponents/buttons/main_button.dart';
import 'package:panda/provider/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../../../models/customer_profile_model.dart';
import '../../../../util/ui_constant.dart';

class PaymentDetail extends StatelessWidget {
  const PaymentDetail({Key? key, required this.req}) : super(key: key);
  final PaymentsItem req;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    deleteCard(){
        context.read<ProfileProvider>().removeCard(context,req.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Detail',
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height*0.06,
              ),
              const Center(child: Text("Card Detail Information",style: KAppTitleTextStyle, )),
              SizedBox(
                height: height*0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Expanded(child: Text('Card number', style: KAppBodyTextStyle)),

                  Flexible(
                      child: Text(req.id.toString(),
                          style: KAppBodyTextStyle.copyWith(
                              color: KPColor, fontWeight: FontWeight.w700)))
                ],
              ),

              SizedBox(
                  height: height * 0.03,
                  child: const Divider(
                    thickness: 2,
                  )),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Expanded(child: Text('CVC', style: KAppBodyTextStyle)),

                  Flexible(
                      child: Text(req.cvc.toString(),
                          style: KAppBodyTextStyle.copyWith(
                              color: KPColor, fontWeight: FontWeight.w700)))
                ],
              ),

              SizedBox(
                  height: height * 0.03,
                  child: const Divider(
                    thickness: 2,
                  )),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Expanded(child: Text('Expiration', style: KAppBodyTextStyle)),

                  Flexible(
                      child: Text(req.expiryDate.toString(),
                          style: KAppBodyTextStyle.copyWith(
                              color: KPColor, fontWeight: FontWeight.w700)))
                ],
              ),

              Expanded(child: Container()),

              mainButton("Delete", deleteCard, Colors.red)


            ],
          ),
      ),
      );
  }
}