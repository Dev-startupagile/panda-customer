import 'package:flutter/material.dart';
import 'package:panda/commonComponents/skeletal/skeletal_card.dart';

class CustomCardSkeletal extends StatelessWidget {
  const CustomCardSkeletal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        const SkeletonContainer.square(
          width: 90,
          height: 50,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SkeletonContainer.rounded(
              width: MediaQuery.of(context).size.width * .5,
              height: 25,
            ),
            const SizedBox(height: 8),
            const SkeletonContainer.rounded(
              width: 60,
              height: 13,
            ),
          ],
        ),
      ],
    );
  }
}
