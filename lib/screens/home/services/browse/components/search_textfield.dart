import 'package:flutter/material.dart';

import '../../../../../util/ui_constant.dart';

Widget customSearchTextField(searchController,hintText, BuildContext context, searchMechanic) => TextFormField(
  autofocus: false,
  controller: searchController,
  cursorColor: Colors.blueGrey,
  keyboardType: TextInputType.name,
  textInputAction: TextInputAction.go,
  onChanged: (value) {
    searchMechanic(value);
  },

  decoration: InputDecoration(
      hintText: hintText,

      hintStyle: KHintTextStyle,
      prefixIcon:  const Icon(Icons.search,color: KHintColor,),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: KBorderColor )
      ),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: KBorderColor )
      ),
      suffixIcon: IconButton(
        icon: const Icon(Icons.filter_list_sharp,color: KHintColor,),
        onPressed: () =>searchController.clear(),
      )

  ),
);