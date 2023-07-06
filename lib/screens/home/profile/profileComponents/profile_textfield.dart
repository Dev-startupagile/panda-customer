import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_cvc_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_expiration_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_number_input_formatter.dart';

import '../../../../function/validation/auth_validation.dart';
import '../../../../function/validation/payment_validator.dart';
import '../../../../util/ui_constant.dart';

Widget customProfileTextField(icon, isTextArea, type,nameController,hintText, BuildContext context, Function() submitData) => Card(
  child:   TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    // autofocus: false,
    controller: nameController,
    cursorColor: Colors.blueGrey,
    maxLines: 1,
    keyboardType:  type == "text"? TextInputType.name: TextInputType.number,
    textInputAction: TextInputAction.go,
    validator: nameValidator,
    decoration:
    InputDecoration(
      hintText: hintText,

      hintStyle: KHintTextStyle,
      contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
      prefixIcon:  Icon(icon,color: KHintColor,),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xffE5E5E5),
        ),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xffE5E5E5),
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 2,
          color: Color.fromARGB(113, 229, 229, 229),
        ),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 2,
        ),
      ),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          )),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 1,
          color: Colors.red,
        ),
      ),      ),
  ),
);


Widget customCVCTextField(cardNumberValidator,cvcController,hintText,cardType, BuildContext context, Function() submitData) =>TextFormField(
    controller: cvcController,
    keyboardType: TextInputType.number,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    onChanged: (String val){
      cardNumberValidator(val);
    },
    validator:
    cardType == "CardNumber"?cardValidator: cardType == "Expiration"? expirationValidator:cvcValidator,
    cursorColor: Colors.blueGrey,
    inputFormatters: [
      cardType == "CardNumber"?
      CreditCardNumberInputFormatter():
      cardType == "Expiration"?
      CreditCardExpirationDateFormatter():
      CreditCardCvcInputFormatter()
    ],
    textInputAction: TextInputAction.go,
    decoration: InputDecoration(
        hintText: hintText,
        hintStyle: KHintTextStyle,
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xffE5E5E5),
        ),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xffE5E5E5),
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 2,
          color: Color.fromARGB(113, 229, 229, 229),
        ),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 2,
        ),
      ),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          )),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 1,
          color: Colors.red,
        ),
      ),
    )
);



Widget customContactUsTextField(icon, isTextArea, type,nameController,hintText, BuildContext context, Function() submitData) =>
  TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    // autofocus: false,
    controller: nameController,
    cursorColor: Colors.blueGrey,
    maxLines: isTextArea? 8:1,
    maxLength: isTextArea?20:null,
    keyboardType:  type == "text"? TextInputType.name: TextInputType.number,
    textInputAction: TextInputAction.go,
    validator: nameValidator,
    decoration:
    InputDecoration(
      hintText: hintText,

      hintStyle: KHintTextStyle,
      contentPadding: const EdgeInsets.all(10),
      prefixIcon: isTextArea? null: Icon(icon,color: KHintColor,),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xffE5E5E5),
        ),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 1,
          color: Color(0xffE5E5E5),
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 2,
          color: Color.fromARGB(113, 229, 229, 229),
        ),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 2,
        ),
      ),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          )),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          width: 1,
          color: Colors.red,
        ),
      ),      ),
  );

