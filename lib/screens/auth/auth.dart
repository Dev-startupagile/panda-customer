import 'dart:io';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as ac;
import 'package:amplify_flutter/amplify_flutter.dart' as af;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panda/function/validation/auth_validation.dart';
import 'package:panda/models/signup_form_model.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:panda/screens/auth/social_login_widget.dart';
import 'package:panda/util/app_icons.dart';
import 'package:panda/util/constants.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';
import '../../../provider/auth_provider.dart';
import '../../../util/ui_constant.dart';
import '../../commonComponents/image_picker_bottomsheet.dart';
import '../../commonComponents/profile_avatar.dart';
import '../../commonComponents/skeletal/custom_auto_complete_skeletal.dart';
import '../../commonComponents/term_of_use.dart';
import '../../function/image_cropper.dart';
import '../../function/substring.dart';
import '../../function/validation/validationService.dart';
import '../../provider/auto_complete_provider.dart';
import '../../provider/uploader_provider.dart';
import 'authComponent/auth_textfield.dart';

import 'authComponent/password_hint.dart';

enum AvaliableSocialLogin { google, facebook, apple }

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
  bool firstPage = true;
  AvaliableSocialLogin? avaliableSocialLogin;
  bool secondPage = false;
  bool isChecked = false;
  String countryCode = '';
  String? placeQuery;
  String phoneNumber = '';
  String fcmToken = '';

  bool phoneAgreed = false;

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
        fcmToken = value!;
      });
    });

    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    //TODO: DOn't fortget to remove
    // emailController =
    // TextEditingController(text: "baslielselamu2018+pc@gmail.com");
    emailController = TextEditingController();
    // passwordController = TextEditingController(text: "Ap2334\$56");
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
        nameValidator(stateController.text) != null) {
      displayErrorSnackBar(context, nameValidator(stateController.text) ?? "");
    } else if (cityController.text.isNotEmpty &&
        nameValidator(cityController.text) != null) {
      displayErrorSnackBar(context, nameValidator(cityController.text) ?? "");
    } else if (streetController.text.isNotEmpty &&
        streetValidator(streetController.text) != null) {
      displayErrorSnackBar(
          context, streetValidator(streetController.text) ?? "");
    } else if (zipcodeController.text.isNotEmpty &&
        zipcodeValidator(zipcodeController.text) != null) {
      displayErrorSnackBar(
          context, zipcodeValidator(zipcodeController.text) ?? "");
    } else {
      if (isChecked) {
        SignUpModel signupmodel = SignUpModel(
            firstName: firstnameController.text,
            lastName: lastnameController.text,
            profilePicture: context.read<UploaderProvider>().uplodedFile ?? "",
            email: emailController.text,
            // phoneNumber: formatPhoneNumber(phoneNumber),
            phoneNumber: phoneNumber,
            state: stateController.text,
            city: cityController.text,
            password: passwordController.text,
            zipCode: zipcodeController.text.isNotEmpty
                ? int.parse(zipcodeController.text)
                : 000,
            userRole: "customer",
            street: streetController.text,
            fcm_token: fcmToken);
        context.read<AuthProvider>().signUp(context, signupmodel);
      } else {
        displayInfoSnackBar(
            context, "You have to accept our Terms & Conditions  first");
      }
    }
  }

  void submitData() {
    _formKey.currentState!.save();

    if (signUp) {
      if (firstPage) {
        if (emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty) {
          if (is8Char(passwordController.text) &&
              containsNumb(passwordController.text) &&
              containsLowerCase(passwordController.text) &&
              containsUpperCase(passwordController.text) &&
              containsSymbols(passwordController.text)) {
            if (emailValidator(emailController.text) != null) {
              displayErrorSnackBar(
                  context, emailValidator(emailController.text) ?? "");
            } else {
              setState(() {
                firstPage = false;
              });
            }
          } else {
            displayErrorSnackBar(context, "please enter valid password ");
          }
        }
        return;
      }
      if (!firstPage &&
          firstnameController.text.isNotEmpty &&
          lastnameController.text.isNotEmpty &&
          phoneNumber != '') {
        if (!phoneAgreed) {
          return displayErrorSnackBar(
              context, "You must agree to recieve text messages");
        }
        if (_image != null) {
          if (nameValidator(firstnameController.text) != null) {
            displayErrorSnackBar(
                context, nameValidator(firstnameController.text) ?? "");
          } else if (nameValidator(lastnameController.text) != null) {
            displayErrorSnackBar(
                context, nameValidator(lastnameController.text) ?? "");
          } else if (phoneValidation != null) {
            displayErrorSnackBar(context, phoneValidation ?? "");
          } else if (passwordValidator(passwordController.text) != null) {
            displayErrorSnackBar(
                context, passwordValidator(passwordController.text) ?? "");
          } else {
            setState(() {
              secondPage = true;
            });
          }
        } else {
          displayErrorSnackBar(context, "please upload profile picture ");
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
              passwordController.text, fcmToken, toggleSignIn);
        }
      } else {
        displayErrorSnackBar(context, "Please fill out the above form ");
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
                        if (secondPage) {
                          setState(() {
                            secondPage = false;
                          });
                        } else {
                          setState(() {
                            firstPage = true;
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
                              child: Image.asset(
                                "assets/login-illustrator.jpg",
                                height: 200,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Column(
                              children: [
                                Visibility(
                                  visible: signUp && !firstPage && !secondPage,
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
                                  visible: !secondPage,
                                  child: Column(
                                    children: [
                                      Visibility(
                                          visible: signUp &&
                                              !firstPage &&
                                              !secondPage,
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
                                          visible: signUp &&
                                              !firstPage &&
                                              !secondPage,
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
                                        visible: firstPage,
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
                                        visible: firstPage,
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
                                              firstPage &&
                                              ishintPassowrdShow,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: passwordHint(
                                                  passwordController.text))),
                                      Visibility(
                                          visible: signUp && firstPage,
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
                                          visible: signUp &&
                                              !firstPage &&
                                              !secondPage,
                                          child: CustomPhoneTextField(
                                              phoneValidation: phoneValidation,
                                              phoneValidationSetter:
                                                  phoneValidationSetter,
                                              phoneNumberSetter:
                                                  phoneNumberSetter,
                                              phoneController:
                                                  phoneController)),
                                      Visibility(
                                        visible:
                                            signUp && !firstPage && !secondPage,
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 15, 0, 15),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Checkbox(
                                                    checkColor: Colors.white,
                                                    value: phoneAgreed,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        phoneAgreed =
                                                            !phoneAgreed;
                                                      });
                                                    },
                                                  ),
                                                  const Expanded(
                                                    child: Text(
                                                      "By checking this box you agree to receive text messages at the number provided.",
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ])),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Visibility(
                                    visible: secondPage,
                                    child: Column(
                                      children: [
                                        CustomAuthTextField(
                                          isTag: false,
                                          isState: false,
                                          isNumber: false,
                                          icon: Icons.location_city,
                                          nameController: streetController,
                                          hintText: "Street (Optional)",
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
                                          hintText: "City (Optional)",
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
                                          hintText: "State (Optional)",
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
                                          hintText: "Zip Code (Optional)",
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
                                          visible: secondPage && signUp,
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
                                Visibility(
                                  visible: firstPage && !secondPage,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                                  height: 1,
                                                  color: const Color.fromARGB(
                                                      255, 79, 78, 78))),
                                          const SizedBox(width: 5),
                                          const Text("OR"),
                                          const SizedBox(width: 5),
                                          Expanded(
                                              child: Container(
                                                  height: 1,
                                                  color: const Color.fromARGB(
                                                      255, 79, 78, 78))),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      SocialLoginBtn(
                                          fillColor: Colors.white,
                                          icon: AppIcons.googleIcon,
                                          textColor: Colors.black,
                                          isSignIn: !signUp,
                                          onTap: () => signInWithSocial(
                                              context,
                                              !signUp,
                                              AvaliableSocialLogin.google),
                                          name: "Google"),
                                      SocialLoginBtn(
                                          fillColor: Colors.white,
                                          icon: AppIcons.appleIcon,
                                          textColor: Colors.black,
                                          isSignIn: !signUp,
                                          onTap: () => signInWithSocial(
                                              context,
                                              !signUp,
                                              AvaliableSocialLogin.apple),
                                          name: "Apple"),
                                      SocialLoginBtn(
                                          fillColor: const Color(0xff1877f2),
                                          icon: AppIcons.facebookIcon,
                                          textColor: Colors.white,
                                          isSignIn: !signUp,
                                          onTap: () => signInWithSocial(
                                              context,
                                              !signUp,
                                              AvaliableSocialLogin.facebook),
                                          name: "Facebook"),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                MaterialButton(
                                  onPressed: () {
                                    secondPage ? submitAllData() : submitData();
                                  },
                                  height: 48,
                                  minWidth: double.infinity,
                                  color: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: signUp
                                      ? Text(secondPage ? "SIGN UP" : "NEXT",
                                          style: KAuthTextStyle)
                                      : Text("LOGIN", style: KAuthTextStyle),
                                ),
                                SizedBox(height: height * 0.05),
                                Visibility(
                                  visible:
                                      !context.watch<AuthProvider>().isLoading,
                                  child: GestureDetector(
                                    onTap: toggleSignIn,
                                    child: signUp
                                        ? Visibility(
                                            visible: !secondPage,
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

  void toggleSignIn() {
    setState(() {
      signUp = !signUp;
      if (!signUp) firstPage = true;
    });
    clearControllers();
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
    } on PlatformException catch (_) {
      Navigator.of(context).pop();
    }
  }

  Future _uploadProfilePic(BuildContext context) async {
    if (_image != null) {
      context.read<UploaderProvider>().imageUploader(context, _image!);
    }
  }

  Future<void> signInWithSocial(BuildContext context, bool signIn,
      AvaliableSocialLogin socialLogin) async {
    try {
      context.read<AuthProvider>().dialog.openLoadingDialog(context);
      ac.AuthProvider authProvider = socialLogin == AvaliableSocialLogin.google
          ? ac.AuthProvider.google
          : socialLogin == AvaliableSocialLogin.facebook
              ? ac.AuthProvider.facebook
              : ac.AuthProvider.apple;
      print("Signed in with $socialLogin");
      ac.SignInResult res =
          await af.Amplify.Auth.signInWithWebUI(provider: authProvider);
      print("Sign in result ${res.isSignedIn}");
      if (res.isSignedIn) {
        try {
          List<ac.AuthUserAttribute> listOfAttr =
              await af.Amplify.Auth.fetchUserAttributes();
          String? email;
          String? name;
          if (listOfAttr
              .where((element) => element.userAttributeKey.key == "email")
              .isNotEmpty) {
            email = listOfAttr
                .firstWhere(
                    (element) => element.userAttributeKey.key == "email")
                .value;
          }
          if (listOfAttr
              .where((element) => element.userAttributeKey.key == "name")
              .isNotEmpty) {
            name = listOfAttr
                .firstWhere((element) => element.userAttributeKey.key == "name")
                .value;
          }
          Navigator.pop(context);

          print("User's email: $email");

          if (signIn) {
            context.read<AuthProvider>().signIn(
                context, email, kDefaultPassword, fcmToken, toggleSignIn);
          } else {
            if (socialLogin == AvaliableSocialLogin.google ||
                socialLogin == AvaliableSocialLogin.apple) {
              if (name != null && name.contains(" ")) {
                var bothName = name.split(" ");
                firstnameController.text = bothName[0];
                lastnameController.text = bothName[1];
              } else {
                firstnameController.text = name ?? '';
              }
              emailController.text = email ?? '';
            }

            passwordController.text = kDefaultPassword;
            confirmPasswordController.text = kDefaultPassword;
            setState(() {
              firstPage = false;
              avaliableSocialLogin = socialLogin;
            });
          }
        } catch (e) {
          print("Error getting user data: $e");
          Navigator.of(context).pop();
        }
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } on ac.AuthException catch (e) {
      print(e.message);
      Navigator.pop(context);
    } catch (e) {
      print("Error getting user data: $e");
      Navigator.pop(context);
    }
  }
}
