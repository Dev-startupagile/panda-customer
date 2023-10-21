import 'package:flutter/material.dart';
import 'package:panda/commonComponents/skeletal/skeletal_card.dart';

class CustomAutoCompleteCardSkeletal extends StatelessWidget {
  const CustomAutoCompleteCardSkeletal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SkeletonContainer.rounded(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 10,
            ),
            const Divider()
          ],
        ),
      ],
    );
  }
}