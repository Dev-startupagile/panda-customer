import 'package:flutter/material.dart';
import 'package:panda/commonComponents/skeletal/skeletal_card.dart';

class CustomProfileSkeletal extends StatelessWidget {
  const CustomProfileSkeletal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(width: 16),

        const Center(
          child: SkeletonContainer.circular(
            width: 150,
            height: 150,
          ),
        ),

        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SkeletonContainer.rounded(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 25,
            ),
            const SizedBox(height: 8),
            const SkeletonContainer.rounded(
              width: 60,
              height: 13,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SkeletonContainer.rounded(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 25,
            ),
            const SizedBox(height: 8),
            const SkeletonContainer.rounded(
              width: 60,
              height: 13,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SkeletonContainer.rounded(
              width: MediaQuery.of(context).size.width * 0.6,
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