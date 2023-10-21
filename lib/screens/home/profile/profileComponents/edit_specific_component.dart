import 'package:flutter/material.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:panda/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import '../../../../function/validation/auth_validation.dart';
import '../../../../function/validation/validationService.dart';
import '../../../../util/constants.dart';
import '../../../../util/ui_constant.dart';
import '../../../auth/authComponent/auth_textfield.dart';
import '../../../auth/authComponent/password_hint.dart';

class EditSpecificComponent extends StatefulWidget {
  EditSpecificComponent({ this.editAddressData, required this.email, required this.editType,required this.editData, Key? key}) : super(key: key);
  String editType;
  String editData;
  String email;
  List? editAddressData;

  @override
  State<EditSpecificComponent> createState() => _EditSpecificComponentState();
}

class _EditSpecificComponentState extends State<EditSpecificComponent> {
  final _formKey = GlobalKey<FormState>();
  bool isNewPasswordNotVisible = true;
  bool isCurrentPasswordNotVisible = true;
  bool isPasswordValidated = false;
  String countryCode = '';
  Map<String,dynamic>? requestBody;
  String phoneNumber = '';
  String? phoneValidation;
  bool ishintPassowrdShow = false;

  void phoneValidationSetter(String? value){
    setState(() {
      phoneValidation = value;
    });
  }

  late  TextEditingController firstnameController;
  late  TextEditingController lastnameController;
  late  TextEditingController  phoneController;
  late  TextEditingController emailController;
  late  TextEditingController oldPasswordController;
  late  TextEditingController newPasswordController;
  late  TextEditingController  confirmPasswordController ;

  late  TextEditingController stateController;
  late  TextEditingController cityController;
  late  TextEditingController streetController;
  late  TextEditingController  zipcodeController ;
  late  TextEditingController hourlyfeeController;
  late  TextEditingController diagnosticfeeController;

  void changeNewPassVisibility(){
    setState(() {
      isNewPasswordNotVisible = !isNewPasswordNotVisible;
    });
  }
  void changeOldPassVisibility(){
    setState(() {
      isCurrentPasswordNotVisible = !isCurrentPasswordNotVisible;
    });
  }
  @override
  void initState() {

    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    emailController = TextEditingController();
    newPasswordController = TextEditingController();
    oldPasswordController = TextEditingController();

    confirmPasswordController = TextEditingController();
    phoneController = TextEditingController();
    stateController = TextEditingController();
    cityController =  TextEditingController();
    streetController = TextEditingController();
    zipcodeController =  TextEditingController();
    hourlyfeeController  = TextEditingController();
    diagnosticfeeController  = TextEditingController();

    if(widget.editType == fullNameConst ){
      setFullName();
    }
    if(widget.editType == emailConst){
      setEmail();
    }
    if(widget.editType == phoneNumberConst ){
      setPhoneNumber();
    }
    if(widget.editType == addressConst){
      setAddress();
    }

    super.initState();
  }

  setAddress(){
    cityController.text = widget.editAddressData![0];
    stateController.text = widget.editAddressData![1];
    zipcodeController.text =widget.editAddressData![2].toString();
    streetController.text = widget.editAddressData![3];
  }


  setPhoneNumber(){
    phoneController.text = widget.editData;
  }

  setEmail(){
    emailController.text = widget.editData;
  }


  setFullName(){

    List fullNameList = widget.editData.split(" ");
    String newFirstName = "";
    String newLastName = "";

    if (fullNameList.length > 1) {
      newLastName = fullNameList[fullNameList.length - 1].toString().trim();
      newFirstName = widget.editData.substring(0, widget.editData.length - newLastName.length).trim();
    } else {
      newFirstName = widget.editData.toString();
    }
    firstnameController.text = newFirstName;
    lastnameController.text = newLastName;

  }

  void setCountryNumber(String value){
    setState(() {
      countryCode = value;
    });
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    streetController.dispose();
    super.dispose();
  }

  responseGenerator(firstString, lastString){
    setState((){
      requestBody = {"$firstString":lastString};
    });
  }

  fullNameResponseGenerator(firstString, lastString, firstname,lastname){
    setState((){
      requestBody = {
        "$firstString":firstname,
        "$lastString":lastname
      };
    });
  }

  addressResponseGenerator(city,street,zipcode,state){
    setState((){
      requestBody = {
        "city":city,
        "street":street,
        "zipCode": int.parse(zipcode),
        "state":state,
      };
    });
  }

  submitData(){
          if(widget.editType == passwordConst){
            if( is8Char(newPasswordController.text) && containsNumb(newPasswordController.text)
                && containsLowerCase(newPasswordController.text) && containsUpperCase(newPasswordController.text)
                && containsSymbols(newPasswordController.text)){
               if(passwordValidator(newPasswordController.text) != null){
                displayErrorSnackBar(context, passwordValidator(newPasswordController.text) ?? "");
               }else{
                 context.read<ProfileProvider>().
                 editPassword(context,
                     emailController.text,
                     oldPasswordController.text,
                     newPasswordController.text
                 );
               }

            }else{
              displayInfoSnackBar(context, "please enter valid password first");
            }
          }

          else if(widget.editType == fullNameConst){

            if(firstnameController.text.isNotEmpty && lastnameController.text.isNotEmpty ){
              if(nameValidator(firstnameController.text) != null){
                displayErrorSnackBar(context, nameValidator(firstnameController.text) ?? "");
              }else if(nameValidator(lastnameController.text) != null){
                displayErrorSnackBar(context, nameValidator(lastnameController.text) ?? "");
              }else{
                fullNameResponseGenerator(
                    "firstName","lastName", firstnameController.text, lastnameController.text);
                submitProfile();
              }
            }else{
              displayErrorSnackBar(context, "Enter Required data");
            }

          }

          else if(widget.editType == emailConst){
            if(emailController.text.isNotEmpty ){
               if(emailValidator(emailController.text) != null){
                displayErrorSnackBar(context, emailValidator(emailController.text) ?? "");
              }else{
                responseGenerator("email", emailController.text);
                submitProfile();
              }
            }else{
              displayErrorSnackBar(context, "Enter Required data");
            }

          }
          else if(widget.editType == phoneNumberConst){
             if(phoneValidation != null){
              displayErrorSnackBar(context, phoneValidation ?? "");
             }else{
               responseGenerator("phoneNumber", phoneController.text);
               submitProfile();
               }
          } else if(widget.editType == addressConst ){
            if (
            stateController.text.isNotEmpty && cityController.text.isNotEmpty &&
                streetController.text.isNotEmpty && zipcodeController.text.isNotEmpty
            ) {
              if(nameValidator(stateController.text) != null){
                displayErrorSnackBar(context, nameValidator(stateController.text) ?? "");
              }else if(nameValidator(cityController.text) != null){
                displayErrorSnackBar(context, nameValidator(cityController.text) ?? "");
              }else if(streetValidator(streetController.text) != null){
                displayErrorSnackBar(context, streetValidator(streetController.text) ?? "");
              }else if(zipcodeValidator(zipcodeController.text) != null){
                displayErrorSnackBar(context, zipcodeValidator(zipcodeController.text) ?? "");
              }else{
                addressResponseGenerator(cityController.text, streetController.text, zipcodeController.text, stateController.text);
                submitProfile();
              }
            }else{
              displayErrorSnackBar(context, "Please Enter required field ");
            }

          } else{
            Navigator.pop(context);
          }

  }

  submitProfile(){
    context.read<ProfileProvider>().editProfileInformation(context, widget.email, requestBody);
  }
  void phoneNumberSetter(String value){
    setState(() {
      phoneNumber = value;
    });
  }
  void hintPasswordShower(){
    setState(() {
      ishintPassowrdShow = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
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
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                SizedBox(height: height * 0.1),

                Visibility(
                  visible: widget.editType == fullNameConst,
                    child: Column(
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("First Name", style: KLatoTextStyle,),
                            CustomAuthTextField(isTag: false,isState: false,isNumber: false,icon: Icons.person, nameController: firstnameController, hintText: "First Name", submitData: submitData, isEmail: false, isCity: true, isZipCode: false, isStreet: false, isPassword: false, isConfirmPassword: false,),

                          ],
                        ),

                        SizedBox(height: height * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Last Name", style: KLatoTextStyle,),
                            CustomAuthTextField(isTag: false,isState: false,isNumber: false,icon: Icons.person, nameController: lastnameController, hintText: "Last Name", submitData: submitData, isEmail: false, isCity: true, isZipCode: false, isStreet: false, isPassword: false, isConfirmPassword: false,)

                          ],
                        ),

                      ],
                    )
                ),

                Visibility(
                    visible: widget.editType == emailConst,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email", style: KLatoTextStyle,),
                            CustomAuthTextField(isTag: false,isState: false,isNumber: false,icon:  Icons.email, nameController: emailController, hintText: "Email", submitData: submitData, isEmail: true, isCity: false, isZipCode: false, isStreet: false, isPassword: false, isConfirmPassword: false,),
                          ],
                        ),
                      ],
                    )
                ),

                Visibility(
                    visible: widget.editType == phoneNumberConst,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Phone Number", style: KLatoTextStyle,),
                            CustomPhoneTextField(phoneValidation: phoneValidation,phoneValidationSetter: phoneValidationSetter,phoneController: phoneController, phoneNumberSetter: phoneNumberSetter)

                          ],
                        ),

                      ],
                    )
                ),

                Visibility(
                    visible: widget.editType == addressConst,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Street", style: KLatoTextStyle,),
                            CustomAuthTextField(isTag: false,isState: false,isNumber: false,icon: Icons.location_city, nameController: streetController, hintText: "Street", submitData: submitData, isEmail: false, isCity: true, isZipCode: false, isStreet: false, isPassword: false, isConfirmPassword: false,),

                          ],
                        ),

                        SizedBox(height: height * 0.02),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("City", style: KLatoTextStyle,),
                            CustomAuthTextField(isTag: false,isState: false,isNumber: false,icon: Icons.location_city, nameController: cityController, hintText: "City", submitData: submitData, isEmail: false, isCity: true, isZipCode: false, isStreet: false, isPassword: false, isConfirmPassword: false,),

                          ],
                        ),

                        SizedBox(height: height * 0.02),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("State", style: KLatoTextStyle,),
                            CustomAuthTextField(isTag: false,isState: true,isNumber: false,icon: Icons.location_city, nameController: stateController, hintText: "State", submitData: submitData, isEmail: false, isCity: true, isZipCode: false, isStreet: false, isPassword: false, isConfirmPassword: false,),

                          ],
                        ),

                        SizedBox(height: height * 0.02),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Zip Code", style: KLatoTextStyle,),
                            CustomAuthTextField(isTag: false,isState: false,isNumber: true,icon: Icons.code, nameController: zipcodeController, hintText: "Zip Code", submitData: submitData, isEmail: false, isCity: true, isZipCode: false, isStreet: false, isPassword: false, isConfirmPassword: false,),

                          ],
                        ),

                      ],
                    )
                ),



                Visibility(
                    visible: widget.editType == passwordConst,
                    child: Column(
                      children: [
                        CustomAuthTextField(isTag: false,isState: false,hintPasswordShower:hintPasswordShower,isNumber: false,icon:  Icons.lock, nameController: oldPasswordController, hintText: "Current Password", submitData: submitData, isEmail: false, isCity: false, isZipCode: false, isStreet: false, isPassword: true,isPasswordNotVisible: isCurrentPasswordNotVisible,changeVisibility: changeOldPassVisibility, isConfirmPassword: false,),

                        CustomAuthTextField(isTag: false,isState: false,hintPasswordShower:hintPasswordShower,isNumber: false,icon:  Icons.lock, nameController: newPasswordController, hintText: "New Password", submitData: submitData, isEmail: false, isCity: false, isZipCode: false, isStreet: false, isPassword: true,isPasswordNotVisible: isNewPasswordNotVisible,changeVisibility: changeNewPassVisibility, isConfirmPassword: false,),

                        Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: passwordHint(newPasswordController.text)
                          ),


                        CustomAuthTextField(isTag: false,isState: false,isNumber: false,icon: Icons.lock,isPasswordNotVisible: isNewPasswordNotVisible, nameController: confirmPasswordController, hintText: "Confirm Password", submitData: submitData, isEmail: false, isCity: false, isZipCode: false, isStreet: false, isPassword: false, isConfirmPassword: true)

                      ],
                    )
                ),

                SizedBox(height: height * 0.06),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () {
                      submitData();
                    },
                    height: 40,
                    minWidth: double.infinity,
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(
                        "Save",
                        style: KWhiteTextStyle
                        )
                      ),
                )
              ],
            ),
          ),
        ),
      );
  }
}
