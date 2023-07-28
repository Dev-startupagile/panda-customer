import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panda/function/validation/auth_validation.dart';
import 'package:panda/models/signup_form_model.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';
import '../../../provider/auth_provider.dart';
import '../../../util/ui_constant.dart';
import '../../commonComponents/image_picker_bottomsheet.dart';
import '../../commonComponents/profile_avatar.dart';
import '../../commonComponents/skeletal/custom_auto_complete_skeletal.dart';
import '../../commonComponents/term_of_use.dart';
import '../../function/image_cropper.dart';
import '../../function/phone_number_formatter.dart';
import '../../function/substring.dart';
import '../../function/validation/validationService.dart';
import '../../provider/auto_complete_provider.dart';
import '../../provider/uploader_provider.dart';
import 'authComponent/auth_textfield.dart';

import 'authComponent/password_hint.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormState>();
  late PhoneController phonecontroller;
  String? phoneValidation;

  File? _image;
  String? finalState;
  bool isPasswordValidated = false;
  bool ishintPassowrdShow = false;
  bool signUp = false;
  bool isPasswordNotVisible = true;
  bool SecondPage = false;
  bool isChecked = false;
  String countryCode = '';
  String? placeQuery;
  String phoneNumber = '';
  String fcm_token = '';

  late FirebaseMessaging messaging;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  late TextEditingController stateController;
  late TextEditingController cityController;
  late TextEditingController streetController;
  late TextEditingController zipcodeController;

  @override
  void initState() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      setState(() {
        fcm_token = value!;
      });

      print("fcmTokenn $value");
    });

    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    phoneController = TextEditingController();
    stateController = TextEditingController();
    cityController = TextEditingController();
    streetController = TextEditingController();
    zipcodeController = TextEditingController();
    phonecontroller = PhoneController(null);

    super.initState();
    phonecontroller = PhoneController(null);
    phonecontroller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void clearControllers() {
    firstnameController.clear();
    lastnameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void valueChanger(value) {
    setState(() {
      placeQuery = value;
    });
    context.read<AutoCompleteProvider>().getPlace(context, value);
  }

  void changeVisibility() {
    setState(() {
      isPasswordNotVisible = !isPasswordNotVisible;
    });
  }

  void phoneNumberSetter(String value) {
    setState(() {
      phoneNumber = value;
      print("phoneNumber $phoneNumber");
    });
  }

  void phoneValidationSetter(String? value) {
    setState(() {
      phoneValidation = value;
    });
  }

  void hintPasswordShower() {
    setState(() {
      ishintPassowrdShow = true;
    });
  }

  submitAllData() {
    _formKey.currentState!.save();

    if (stateController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        streetController.text.isNotEmpty &&
        zipcodeController.text.isNotEmpty) {
      if (nameValidator(stateController.text) != null) {
        displayErrorSnackBar(
            context, nameValidator(stateController.text) ?? "");
      } else if (nameValidator(cityController.text) != null) {
        displayErrorSnackBar(context, nameValidator(cityController.text) ?? "");
      } else if (streetValidator(streetController.text) != null) {
        displayErrorSnackBar(
            context, streetValidator(streetController.text) ?? "");
      } else if (zipcodeValidator(zipcodeController.text) != null) {
        displayErrorSnackBar(
            context, zipcodeValidator(zipcodeController.text) ?? "");
      } else {
        if (isChecked) {
          SignUpModel signupmodel = SignUpModel(
              firstName: firstnameController.text,
              lastName: lastnameController.text,
              profilePicture:
                  context.read<UploaderProvider>().uplodedFile ?? "",
              email: emailController.text,
              // phoneNumber: formatPhoneNumber(phoneNumber),
              phoneNumber: phoneNumber,
              state: stateController.text,
              city: cityController.text,
              password: passwordController.text,
              zipCode: int.parse(zipcodeController.text),
              userRole: "customer",
              street: streetController.text,
              fcm_token: fcm_token);
          context.read<AuthProvider>().signUp(context, signupmodel);
        } else {
          displayInfoSnackBar(
              context, "You have to accept our Terms & Conditions  first");
        }
      }
    } else {
      displayErrorSnackBar(context, "Please fill out the above form ");
    }
  }

  submitData() {
    _formKey.currentState!.save();

    if (true) {
      if (signUp) {
        if (firstnameController.text.isNotEmpty &&
            lastnameController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            phoneNumber != '' &&
            passwordController.text.isNotEmpty) {
          if (is8Char(passwordController.text) &&
              containsNumb(passwordController.text) &&
              containsLowerCase(passwordController.text) &&
              containsUpperCase(passwordController.text) &&
              containsSymbols(passwordController.text)) {
            if (_image != null) {
              if (nameValidator(firstnameController.text) != null) {
                displayErrorSnackBar(
                    context, nameValidator(firstnameController.text) ?? "");
              } else if (nameValidator(lastnameController.text) != null) {
                displayErrorSnackBar(
                    context, nameValidator(lastnameController.text) ?? "");
              } else if (emailValidator(emailController.text) != null) {
                displayErrorSnackBar(
                    context, emailValidator(emailController.text) ?? "");
              } else if (phoneValidation != null) {
                displayErrorSnackBar(context, phoneValidation ?? "");
              } else if (passwordValidator(passwordController.text) != null) {
                displayErrorSnackBar(
                    context, passwordValidator(passwordController.text) ?? "");
              } else {
                setState(() {
                  SecondPage = true;
                });
              }
            } else {
              displayErrorSnackBar(context, "please upload profile picture ");
            }
          } else {
            displayErrorSnackBar(context, "please enter valid password ");
          }
        } else {
          displayErrorSnackBar(context, "Please fill out the above form");
        }
      } else {
        if (emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty) {
          if (emailValidator(emailController.text) != null) {
            displayErrorSnackBar(
                context, emailValidator(emailController.text) ?? "");
          } else if (passwordValidator(passwordController.text) != null) {
            displayErrorSnackBar(
                context, passwordValidator(passwordController.text) ?? "");
          } else {
            context.read<AuthProvider>().signIn(context, emailController.text,
                passwordController.text, fcm_token);
          }
        } else {
          displayErrorSnackBar(context, "Please fill out the above form ");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    DateTime timeBackPresed = DateTime.now();

    return WillPopScope(
      onWillPop: () async {
        final diffrence = DateTime.now().difference(timeBackPresed);
        final isExitWarning = diffrence >= const Duration(seconds: 2);
        timeBackPresed = DateTime.now();
        if (isExitWarning) {
          return false;
        } else {
          exit(0);
        }
      },
      child: Scaffold(
          appBar: signUp
              ? AppBar(
                  foregroundColor: Colors.black,
                  title: const Text("Sign Up",
                      style: TextStyle(color: Colors.black)),
                  backgroundColor: Colors.white,
                  leading: BackButton(
                    onPressed: () {
                      setState(() {
                        if (SecondPage) {
                          setState(() {
                            SecondPage = false;
                          });
                        } else {
                          setState(() {
                            signUp = false;
                          });
                        }
                      });
                    },
                  ),
                )
              : null,
          body: Center(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isKeyboard)
                          Visibility(
                            visible: !signUp,
                            child: Center(
                              child: Image.asset("assets/logo.png"),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Column(
                              children: [
                                Visibility(
                                  visible: signUp && !SecondPage,
                                  child: Stack(children: [
                                    InkWell(
                                      onTap: () {
                                        showSelectPhotoOptions(
                                            context, _pickImage);
                                      },
                                      child: Card(
                                        elevation: 8.0,
                                        shape: const CircleBorder(),
                                        clipBehavior: Clip.antiAlias,
                                        child:
                                            profileAvatar(null, _image, false),
                                      ),
                                    ),
                                    if (context
                                        .watch<UploaderProvider>()
                                        .isLoading)
                                      const Positioned(
                                        top: 45,
                                        right: 47,
                                        child: CircularProgressIndicator(
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    Positioned(
                                      bottom: 0,
                                      right: 5,
                                      child: InkWell(
                                        onTap: () {
                                          showSelectPhotoOptions(
                                              context, _pickImage);
                                        },
                                        child: const CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            child: Icon(Icons.photo_camera,
                                                size: 23, color: Colors.white)),
                                      ),
                                    )
                                  ]),
                                ),
                                const SizedBox(height: 20),
                                Visibility(
                                  visible: !SecondPage,
                                  child: Column(
                                    children: [
                                      Visibility(
                                          visible: signUp && !SecondPage,
                                          child: CustomAuthTextField(
                                            isTag: false,
                                            isState: false,
                                            isNumber: false,
                                            icon: Icons.person,
                                            nameController: firstnameController,
                                            hintText: "First Name",
                                            submitData: submitData,
                                            isEmail: false,
                                            isCity: true,
                                            isZipCode: false,
                                            isStreet: false,
                                            isPassword: false,
                                            isConfirmPassword: false,
                                          )),
                                      Visibility(
                                          visible: signUp && !SecondPage,
                                          child: CustomAuthTextField(
                                            isTag: false,
                                            isState: false,
                                            isNumber: false,
                                            icon: Icons.person,
                                            nameController: lastnameController,
                                            hintText: "Last Name",
                                            submitData: submitData,
                                            isEmail: false,
                                            isCity: true,
                                            isZipCode: false,
                                            isStreet: false,
                                            isPassword: false,
                                            isConfirmPassword: false,
                                          )),
                                      Visibility(
                                        visible: !SecondPage,
                                        child: CustomAuthTextField(
                                          isTag: false,
                                          isState: false,
                                          isNumber: false,
                                          icon: Icons.email,
                                          nameController: emailController,
                                          hintText: "Email",
                                          submitData: submitData,
                                          isEmail: true,
                                          isCity: false,
                                          isZipCode: false,
                                          isStreet: false,
                                          isPassword: false,
                                          isConfirmPassword: false,
                                        ),
                                      ),
                                      Visibility(
                                        visible: !SecondPage,
                                        child: CustomAuthTextField(
                                          isTag: false,
                                          isState: false,
                                          hintPasswordShower:
                                              hintPasswordShower,
                                          isNumber: false,
                                          icon: Icons.lock,
                                          nameController: passwordController,
                                          hintText: "Password",
                                          submitData: submitData,
                                          isEmail: false,
                                          isCity: false,
                                          isZipCode: false,
                                          isStreet: false,
                                          isPassword: true,
                                          isPasswordNotVisible:
                                              isPasswordNotVisible,
                                          changeVisibility: changeVisibility,
                                          isConfirmPassword: false,
                                        ),
                                      ),
                                      Visibility(
                                          visible: signUp &&
                                              !SecondPage &&
                                              ishintPassowrdShow,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: passwordHint(
                                                  passwordController.text))),
                                      Visibility(
                                          visible: signUp,
                                          child:
                                              // CustomConfirmPasswordAuthTextField(nameController: confirmPasswordController, submitData: submitData)
                                              CustomAuthTextField(
                                                  isTag: false,
                                                  isState: false,
                                                  isNumber: false,
                                                  icon: Icons.lock,
                                                  isPasswordNotVisible:
                                                      isPasswordNotVisible,
                                                  changeVisibility:
                                                      changeVisibility,
                                                  nameController:
                                                      confirmPasswordController,
                                                  hintText: "Confirm Password",
                                                  submitData: submitData,
                                                  isEmail: false,
                                                  isCity: false,
                                                  isZipCode: false,
                                                  isStreet: false,
                                                  isPassword: false,
                                                  isConfirmPassword: true)),
                                      Visibility(
                                          visible: signUp && !SecondPage,
                                          child: CustomPhoneTextField(
                                              phoneValidation: phoneValidation,
                                              phoneValidationSetter:
                                                  phoneValidationSetter,
                                              phoneNumberSetter:
                                                  phoneNumberSetter,
                                              phoneController:
                                                  phoneController)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Visibility(
                                    visible: SecondPage,
                                    child: Column(
                                      children: [
                                        CustomAuthTextField(
                                          isTag: false,
                                          isState: false,
                                          isNumber: false,
                                          icon: Icons.location_city,
                                          nameController: streetController,
                                          hintText: "Street",
                                          submitData: submitData,
                                          valueChanger: valueChanger,
                                          isEmail: false,
                                          isCity: false,
                                          isZipCode: false,
                                          isStreet: true,
                                          isPassword: false,
                                          isConfirmPassword: false,
                                        ),
                                        if (placeQuery != null)
                                          Consumer<AutoCompleteProvider>(
                                              builder: (context, value, child) {
                                            return value.isLoading
                                                ? ListView.builder(
                                                    itemCount: 3,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return const CustomAutoCompleteCardSkeletal();
                                                    })
                                                : ListView.builder(
                                                    itemCount:
                                                        value.placeList?.length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final req = value
                                                          .placeList![index];
                                                      return Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                streetController
                                                                        .text =
                                                                    getStreet(req
                                                                        ?.description);
                                                                cityController
                                                                        .text =
                                                                    getCity(req
                                                                        ?.description);
                                                                stateController
                                                                        .text =
                                                                    getState(req
                                                                        ?.description);

                                                                placeQuery =
                                                                    null;
                                                              });
                                                            },
                                                            child: ListTile(
                                                              title: Text(
                                                                  req?.description ??
                                                                      ""),
                                                            ),
                                                          ),
                                                          const Divider()
                                                        ],
                                                      );
                                                    });
                                          }),
                                        const SizedBox(height: 20),
                                        CustomAuthTextField(
                                          isTag: false,
                                          isState: false,
                                          isNumber: false,
                                          icon: Icons.location_city,
                                          nameController: cityController,
                                          hintText: "City",
                                          submitData: submitData,
                                          isEmail: false,
                                          isCity: true,
                                          isZipCode: false,
                                          isStreet: false,
                                          isPassword: false,
                                          isConfirmPassword: false,
                                        ),
                                        const SizedBox(height: 20),
                                        CustomAuthTextField(
                                          isTag: false,
                                          isState: true,
                                          isNumber: false,
                                          icon: Icons.location_city,
                                          nameController: stateController,
                                          hintText: "State",
                                          submitData: submitData,
                                          isEmail: false,
                                          isCity: false,
                                          isZipCode: false,
                                          isStreet: true,
                                          isPassword: false,
                                          isConfirmPassword: false,
                                        ),
                                        const SizedBox(height: 20),
                                        CustomAuthTextField(
                                          isTag: false,
                                          isState: false,
                                          isNumber: true,
                                          icon: Icons.code,
                                          nameController: zipcodeController,
                                          hintText: "Zip Code",
                                          submitData: submitData,
                                          isEmail: false,
                                          isCity: false,
                                          isZipCode: true,
                                          isStreet: false,
                                          isPassword: false,
                                          isConfirmPassword: false,
                                        ),
                                        SizedBox(height: height * 0.03),
                                        Visibility(
                                          visible: SecondPage && signUp,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                  value: isChecked,
                                                  activeColor: kPrimaryColor,
                                                  onChanged: (newVal) {
                                                    setState(() {
                                                      isChecked = newVal!;
                                                    });
                                                  }),
                                              const TermsOfUse(),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: height * 0.03),
                                      ],
                                    )),
                                Visibility(
                                  visible: !signUp,
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, "/forget");
                                      },
                                      child: Text(
                                        "Forgot password?                                            ",
                                        style: KNativeTextStyle,
                                      )),
                                ),
                                SizedBox(height: height * 0.02),
                                MaterialButton(
                                  onPressed: () {
                                    SecondPage ? submitAllData() : submitData();
                                  },
                                  height: 48,
                                  minWidth: double.infinity,
                                  color: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: signUp
                                      ? Text(SecondPage ? "SIGN UP" : "NEXT",
                                          style: KAuthTextStyle)
                                      : Text("LOGIN", style: KAuthTextStyle),
                                ),
                                SizedBox(height: height * 0.05),
                                Visibility(
                                  visible:
                                      !context.watch<AuthProvider>().isLoading,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        signUp = !signUp;
                                      });
                                      clearControllers();
                                    },
                                    child: signUp
                                        ? Visibility(
                                            visible: !SecondPage,
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Have an account? ",
                                                    style: KNormalTextStyle,
                                                  ),
                                                  TextSpan(
                                                    text: "Sign In",
                                                    style: KNativeTextStyle,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Not a member? ",
                                                  style: KNormalTextStyle,
                                                ),
                                                TextSpan(
                                                  text: "Sign Up Now",
                                                  style: KNativeTextStyle,
                                                )
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(height: height * 0.05),
                              ],
                            ),
                          ],
                        )
                      ]),
                ),
              ),
            ),
          )),
    );
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(imageFile: img);
      setState(() {
        _image = img;
        _uploadProfilePic(context);
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
    }
  }

  Future _uploadProfilePic(BuildContext context) async {
    if (_image != null) {
      context.read<UploaderProvider>().imageUploader(context, _image!);
    }
  }
}
