import 'package:flutter/material.dart';
import 'package:panda/screens/auth/authComponent/auth_textfield.dart';
import 'package:provider/provider.dart';

import '../../../function/global_snackbar.dart';
import '../../../function/validation/auth_validation.dart';
import '../../../provider/auth_provider.dart';
import '../../../util/ui_constant.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController emailController;

  bool isPasswordNotVisible = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  void submitData() {
    _formKey.currentState!.save();
    if (emailController.text.isNotEmpty) {
      if (emailValidator(emailController.text) != null) {
        displayErrorSnackBar(
            context, emailValidator(emailController.text) ?? "");
      } else {
        Provider.of<AuthProvider>(context, listen: false)
            .sendOtp(context, emailController.text, true);
      }
    } else {
      displayErrorSnackBar(context, "Please fill out the above form");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
        body: Center(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!isKeyboard)
              Center(
                child: Image.asset("assets/logo.png"),
              ),
            Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CustomAuthTextField(
                        isNumber: false,
                        icon: Icons.person_outline,
                        nameController: emailController,
                        hintText: "Email",
                        submitData: submitData,
                        isEmail: true,
                        isCity: false,
                        isZipCode: false,
                        isStreet: false,
                        isPassword: false,
                        isConfirmPassword: false,
                        isTag: false,
                        isState: false,
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () {
                          submitData();
                        },
                        height: height * 0.06,
                        minWidth: double.infinity,
                        color: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text("Reset", style: KAuthTextStyle),
                      ),
                      SizedBox(height: height * 0.05),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/login");
                          },
                          child: Text(
                            "Back to Login screen",
                            style: KNativeTextStyle,
                          )),
                    ],
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    ));
  }
}
