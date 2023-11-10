import 'package:flutter/material.dart';

import '../../../../../function/validation/auth_validation.dart';
import '../../../../../util/ui_constant.dart';

Widget customServiceTextField(icon,Function onChangeFunc, type,nameController,hintText, BuildContext context, Function() submitData) => Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Card(
    elevation: 1,
    shadowColor: Colors.black,
    child:   Container(
      width: double.infinity,
      height: 65,
      color: Colors.white,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // autofocus: false,
        controller: nameController,
        cursorColor: Colors.blueGrey,
        maxLines: 1,
        keyboardType:  type == "text"? TextInputType.name: TextInputType.number,
        textInputAction: TextInputAction.go,
        validator: nameValidator,
        onChanged: (val){
          print("ney selamewa $val");
          onChangeFunc(val);
        },
        decoration:
        InputDecoration(
          hintText: hintText,
          // helperText: ' ',
          hintStyle: KHintTextStyle,
          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
          prefixIcon:  Icon(icon,color: KHintColor,),
          border: InputBorder.none,
        ),
      ),
    ),
  ),
);


Widget customNoteTextField(icon, type,nameController,hintText, BuildContext context, Function() submitData) => Padding(
  padding: const EdgeInsets.all(8.0),
  child:  TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: false,
        controller: nameController,
        cursorColor: Colors.blueGrey,
        minLines: 1,
        maxLines: 3,
       keyboardType:  type == "text"? TextInputType.multiline: TextInputType.number,
        textInputAction: TextInputAction.go,
        decoration:
        InputDecoration(
          hintText: hintText,
          hintStyle: KHintTextStyle,
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
          // prefixIcon:  Icon(icon,color: KHintColor,),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan),
          ),
        ),
      ),
  );

