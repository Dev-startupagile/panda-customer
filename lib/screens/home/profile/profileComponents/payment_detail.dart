import 'package:flutter/material.dart';
import 'package:panda/commonComponents/buttons/main_button.dart';
import 'package:panda/models/tokenized_card.dart';
import 'package:panda/provider/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../../../util/ui_constant.dart';

class PaymentDetail extends StatelessWidget {
  const PaymentDetail({Key? key, required this.tokenizedCard})
      : super(key: key);
  final TokenizedCard tokenizedCard;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    deleteCard() {
      context.read<ProfileProvider>().removeCard(context, tokenizedCard.id);
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
              height: height * 0.06,
            ),
            const Center(
                child: Text(
              "Card Detail Information",
              style: KAppTitleTextStyle,
            )),
            SizedBox(
              height: height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                    child: Text('Card ID', style: KAppBodyTextStyle)),
                Flexible(
                    child: Text(tokenizedCard.id,
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
                const Expanded(
                    child: Text('Card number', style: KAppBodyTextStyle)),
                Flexible(
                    child: Text(tokenizedCard.hiddenCN,
                        style: KAppBodyTextStyle.copyWith(
                            color: KPColor, fontWeight: FontWeight.w700)))
              ],
            ),
            SizedBox(
                height: height * 0.03,
                child: const Divider(
                  thickness: 2,
                )),
            Expanded(child: Container()),
            mainButton("Delete", deleteCard, Colors.red)
          ],
        ),
      ),
    );
  }
}
