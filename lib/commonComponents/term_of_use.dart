import 'package:animations/animations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:panda/commonComponents/policy_dialog.dart';
import 'package:panda/util/ui_constant.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SizedBox(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 3,
            softWrap: false,
            text: TextSpan(
              text: "",
              style: KNormalTextStyle,
              children: [
                TextSpan(
                  text: "Terms & Conditions ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showModal(
                        context: context,
                        configuration: const FadeScaleTransitionConfiguration(),
                        builder: (context) {
                          return PolicyDialog(
                            mdFileName: 'terms_and_conditions.md',
                          );
                        },
                      );
                    },
                ),
                const TextSpan(text: "and "),
                TextSpan(
                  text: "Privacy Policy! ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return PolicyDialog(
                            mdFileName: 'privacy_policy.md',
                          );
                        },
                      );
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
