// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:pinput/pinput.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../commonComponents/count_down_timer.dart';
import '../../function/validation/validationService.dart';
import '../../provider/auth_provider.dart';
import '../../function/global_snackbar.dart';
import '../../util/ui_constant.dart';
import 'authComponent/auth_textfield.dart';
import 'authComponent/password_hint.dart';

class Verification extends StatefulWidget {
  Verification(
      {Key? key,
      this.phoneNumber,
      required this.email,
      required this.isFromReset})
      : super(key: key);
  String email;
  String? phoneNumber;
  bool isFromReset;

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool showError = false;
  bool isPasswordValidated = false;

  late CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 2000 * 60;
  var onTapRecognizer;

  late TextEditingController textEditingController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  final focusNode = FocusNode();

  bool resendLoading = false;
  bool verifyLoading = false;
  bool getOTPLoading = false;
  bool ishintPassowrdShow = false;

  bool isPasswordNotVisible = true;
  bool hasError = false;
  String currentText = "";

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };

    textEditingController = TextEditingController();
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
    super.initState();
  }

  void onEnd() {}

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  verifyUser() {
    if (widget.isFromReset) {
      if (passwordController.text.isNotEmpty) {
        if (is8Char(passwordController.text) &&
            containsNumb(passwordController.text) &&
            containsLowerCase(passwordController.text) &&
            containsUpperCase(passwordController.text) &&
            containsSymbols(passwordController.text)) {
          Provider.of<AuthProvider>(context, listen: false).resetPassword(
              context, widget.email, passwordController.text, currentText);
        } else {
          displayErrorSnackBar(context, "please enter valid password ");
        }
      } else {
        displayErrorSnackBar(context, "Enter Your Password ");
      }
    } else {
      Provider.of<AuthProvider>(context, listen: false)
          .verifyUser(context, widget.email, currentText);
    }
  }

  void changeVisibility() {
    setState(() {
      isPasswordNotVisible = !isPasswordNotVisible;
    });
  }

  Future resendOtp() async {
    context.read<AuthProvider>().sendOtp(context, widget.email, false);
  }

  void hintPasswordShower() {
    setState(() {
      ishintPassowrdShow = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Verification',
          style: KProfilePicAppBarTextStyle,
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(
              vertical: width * 0.05, horizontal: width * 0.05),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: width * 0.08),
                const Text(
                  'Please, enter the OTP code that we send to:',
                  style: KAppBodyTextStyle,
                ),
                SizedBox(height: width * 0.01),
                Visibility(
                  visible: widget.phoneNumber != null,
                  child: Text(
                    widget.email ?? "",
                    style: KAppBodyTextStyle.copyWith(
                        color: kPrimaryColor, fontWeight: FontWeight.w700),
                  ),
                ),
                Visibility(
                  visible: widget.isFromReset,
                  child: Text(
                    widget.email ?? "",
                    style: KAppBodyTextStyle.copyWith(
                        color: kPrimaryColor, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: width * 0.04),
                Center(
                  child: Pinput(
                    controller: textEditingController,
                    focusNode: focusNode,
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      if (!(widget.isFromReset)) {
                        verifyUser();
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                ),
                SizedBox(height: width * 0.04),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CountdownTimerDemo()],
                ),
                SizedBox(height: width * 0.04),
                Visibility(
                  visible: widget.isFromReset,
                  child: CustomAuthTextField(
                    isTag: false,
                    isState: false,
                    hintPasswordShower: hintPasswordShower,
                    isNumber: false,
                    icon: Icons.lock,
                    nameController: passwordController,
                    hintText: "Password",
                    submitData: verifyUser,
                    isEmail: false,
                    isCity: false,
                    isZipCode: false,
                    isStreet: false,
                    isPassword: true,
                    isPasswordNotVisible: isPasswordNotVisible,
                    changeVisibility: changeVisibility,
                    isConfirmPassword: false,
                  ),
                ),
                SizedBox(height: width * 0.04),
                Visibility(
                    visible: widget.isFromReset && ishintPassowrdShow,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: passwordHint(passwordController.text))),
                Visibility(
                    visible: widget.isFromReset,
                    child: CustomAuthTextField(
                        isTag: false,
                        isState: false,
                        isNumber: false,
                        icon: Icons.lock,
                        isPasswordNotVisible: isPasswordNotVisible,
                        changeVisibility: changeVisibility,
                        nameController: confirmPasswordController,
                        hintText: "Confirm Password",
                        submitData: verifyUser,
                        isEmail: false,
                        isCity: false,
                        isZipCode: false,
                        isStreet: false,
                        isPassword: false,
                        isConfirmPassword: true)),
                SizedBox(height: width * 0.04),
                const Row(
                  children: [
                    Text(
                      "Didn't you get your OTP code? ",
                      style: KAppBodyTextStyle,
                    ),
                  ],
                ),
                SizedBox(height: width * 0.02),
                InkWell(
                  onTap: () => resendOtp(),
                  child: Text(
                    'Resend OTP code',
                    style: KAppBodyTextStyle.copyWith(
                        color: kPrimaryColor, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: width * 0.06),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentText.length < 4) {
                        displayInfoSnackBar(context, "please enter valid code");
                      } else {
                        verifyUser();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          currentText.length != 4
                              ? KDisableButtonColor
                              : kPrimaryColor),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: width * 0.04,
                          horizontal: width - (width * 0.7)),
                      child: const Text(
                        'Verify',
                        style: KOnBoardGetStartedTextStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
