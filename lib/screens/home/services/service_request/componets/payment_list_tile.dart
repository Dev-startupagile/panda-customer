import 'package:flutter/material.dart';

import '../../../../../util/ui_constant.dart';

Widget customListTile(leadingicon, text,trailingicon,listTilePressed,data) => Material(
    elevation: 0.5,
    shadowColor: kPrimaryColor,
    color: KBGColor,
    child: ListTile(
      leading: Icon(leadingicon),
      title : Text(text,style: KHintTextStyle),
      trailing: IconButton(
        icon: Icon(trailingicon),
        onPressed: (){
          if(data == null){
            listTilePressed();
          }else{
            listTilePressed(data);
          }
        },
      )
    )

);