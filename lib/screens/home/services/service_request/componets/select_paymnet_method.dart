import 'package:flutter/material.dart';
import 'package:panda/screens/home/services/service_request/componets/payment_list_tile.dart';
import 'package:provider/provider.dart';

import '../../../../../commonComponents/skeletal/custom_profile_skeletal.dart';
import '../../../../../function/substring.dart';
import '../../../../../provider/profile_provider.dart';
import '../../../../../util/ui_constant.dart';
import '../../../profile/profileComponents/payment_detail.dart';

class SelectPaymentMethod extends StatelessWidget {
  Function setPaymentId;
  String paymentId;
  SelectPaymentMethod({Key? key, required this.setPaymentId, required this.paymentId}) : super(key: key);
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    void addPayment(){
      Navigator.pushNamed(context, "/add_payment");
    }

    void cardDetail(req){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PaymentDetail(req: req)
        ),
      );
    }

    return SingleChildScrollView(
        child:  Consumer<ProfileProvider>(
            builder: (context,value,child) {
              return value.isLoading ||  value.customerprofile == null?

              const CustomProfileSkeletal():

              Padding(
                padding:  const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Select Your Payment Method",
                      style: KAppTitleTextStyle,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    value.customerprofile!.payments.items.isEmpty?
                    const Center(
                        child:
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("no payment card",style: TextStyle(fontSize: 16),),
                        ))
                        :
                      ListView.builder(
                          itemCount: value.customerprofile?.payments.items.length,
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemBuilder: (context,index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  setPaymentId(value.customerprofile?.payments.items[index].id);
                                },
                                child: Card(
                                  shape: paymentId  == value.customerprofile?.payments.items[index].id?
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      side: BorderSide(
                                          width: 2,
                                          color: kPrimaryColor
                                      )):
                                  null,
                                  child: customListTile(
                                      Icons.credit_card_rounded, "WF Card **** ${ newString(value.customerprofile?.payments.items[index].id ?? "", 4)}",
                                      Icons.arrow_forward_ios_sharp, cardDetail,value.customerprofile?.payments.items[index] ),
                                ),
                              ),
                            );
                          }
                      ),

                    Row(
                      children: [
                        const Icon(Icons.add, color: kPrimaryColor,),
                        TextButton(
                          onPressed: () {
                            addPayment();
                          },
                          child: const Text(
                            'ADD NEW PAYMENT METHOD',
                            style: AdditemTextStyle,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              );
            }
        )
    );
  }
}
