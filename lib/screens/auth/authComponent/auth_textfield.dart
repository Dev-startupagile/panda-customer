import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../function/validation/auth_validation.dart';
import '../../../util/ui_constant.dart';

class CustomAuthTextField extends StatefulWidget {
  IconData icon;

  TextEditingController nameController;
  String hintText;
  Function submitData;
  Function? valueChanger;
  Function? hintPasswordShower;
  bool isEmail;
  bool isCity;
  bool isZipCode;
  bool isPassword;
  bool isConfirmPassword;
  bool isStreet;
  bool isNumber;
  bool isTag;
  bool isState;
  bool? isDescription;
  bool? isPasswordNotVisible;
  Function? changeVisibility;

  CustomAuthTextField({
    required this.isNumber,
    required this.icon,
    required this.nameController,
    required this.hintText,
    required this.submitData,
    this.valueChanger,
    required this.isEmail,
    required this.isCity,
    required this.isZipCode,
    required this.isStreet,
    required this.isPassword,
    this.isDescription,
    required this.isConfirmPassword,
    this.isPasswordNotVisible,
    this.changeVisibility,
    this.hintPasswordShower,
    required this.isTag,
    required this.isState,
    Key? key}) : super(key: key);

  @override
  State<CustomAuthTextField> createState() => _CustomAuthTextFieldState();
}

class _CustomAuthTextFieldState extends State<CustomAuthTextField> {

  String? emailValidation;
  String? streetValidation;
  String? zipcodeValidation;
  String? cityValdation;
  String? nameValidation;
  bool? namValidator;
  bool? isDescription;
  String? passwordValidation;
  String? confirmpasswordValidation;

  void validateForm(value){
    if(widget.isEmail){
      setState((){
        emailValidation = emailValidator(value);
      });
    }else if(widget.isStreet){
      setState((){
        streetValidation = streetValidator(value);
      });
    }else if(widget.isCity){
      setState((){
        streetValidation = streetValidator(value);
      });
    } else if(widget.isZipCode){
      setState((){
        zipcodeValidation = zipcodeValidator(value);
      });
    }else if(widget.isPassword){
      final val = passwordValidator(value);

      setState(() {
        passwordValidation = val;
        confirmpasswordValidation = val;
        widget.hintPasswordShower!();
      });

    }
    else if(widget.isConfirmPassword){
      setState(() {
        confirmpasswordValidation = confirmPasswordValidator(value);
      });
    }else if(widget.isDescription != null){
      setState(() {
        isDescription = true;
      });
    } else{
      setState((){
        nameValidation = nameValidator(value);
      });
    }
  }
   boxShadowColor(){
     if( emailValidation != null){
       return Colors.red;
     }else if(streetValidation != null){
       return Colors.red;
     }else if( zipcodeValidation != null){
       return Colors.red;
     }else if(nameValidation != null){
       return Colors.red;
     } else if(passwordValidation != null ){
       return Colors.red;
     } else if( confirmpasswordValidation != null){
       return Colors.red;
     }
     else if( isDescription != null){
       return Colors.grey.withOpacity(0.2);
     } else{
       return Colors.grey.withOpacity(0.2);
     }
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color:boxShadowColor(),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller:  widget.nameController,
              cursorColor: Colors.blueGrey,
              maxLength: widget.isZipCode? 5 : widget.isDescription != null? 100 : null,
              inputFormatters: <TextInputFormatter>[
                if(widget.isTag) UpperCaseTextFormatter()
                else if(widget.isState) FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),

              ],
              keyboardType:
                  widget.isNumber?
                    TextInputType.number:
                  widget.isEmail?
                    TextInputType.emailAddress:
                    TextInputType.streetAddress,
              textInputAction: TextInputAction.go,
              obscureText: widget.isPasswordNotVisible ?? false,
              onChanged: (value){
                validateForm(value);
                if(widget.valueChanger != null){
                  widget.valueChanger!(value);
                }
              },
              onSaved: (value){
                validateForm(value);
              },
            style: const TextStyle(fontSize: 16),
            cursorWidth: 1,
            decoration:  InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  errorStyle: const TextStyle(
                    color: Colors.transparent,
                    fontSize: 0,
                    height: 0
                  ),
                  prefixIcon: Icon(
                    widget.icon,
                    color: KHintColor,
                  ),
                  suffixIcon:
                  widget.isPassword?
                  IconButton(
                      icon:  widget.isPasswordNotVisible!
                          ? const Icon(
                        Icons.visibility_off,
                        color: KHintColor,
                      )
                          : const Icon(
                        Icons.visibility,
                        color: KHintColor,
                      ),
                      onPressed: () =>  widget.changeVisibility!()
                  )
                      :
                  null
                  ,
              ),
            ),
        ),
        ),
      );
  }
}

class CustomPhoneTextField extends StatefulWidget {
  TextEditingController phoneController;
  Function phoneNumberSetter;
  Function phoneValidationSetter;
  String? phoneValidation;
  CustomPhoneTextField({ required this.phoneValidation, required this.phoneValidationSetter, required this.phoneNumberSetter, required this.phoneController, Key? key}) : super(key: key);

  @override
  State<CustomPhoneTextField> createState() => _CustomPhoneTextFieldState();
}

class _CustomPhoneTextFieldState extends State<CustomPhoneTextField> {
  PhoneNumber number = PhoneNumber(isoCode: 'US');

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color:
              widget.phoneValidation != null?
              Colors.red:
              Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child:  InternationalPhoneNumberInput(
          inputBorder: InputBorder.none,
          maxLength: 12,
          onInputChanged: (PhoneNumber number) {
            widget.phoneValidationSetter(phoneValidator(number.phoneNumber));
            widget.phoneNumberSetter(number.phoneNumber);
          },

          formatInput: true,
          onInputValidated: (bool value) {},
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: const TextStyle(color: Colors.black),
          initialValue: number,
          textFieldController: widget.phoneController,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          onSaved: (PhoneNumber number) {
            widget.phoneValidationSetter(phoneValidator(number.phoneNumber));
            widget.phoneNumberSetter(number.phoneNumber);
          },
        ),
      ),
    );
  }
}