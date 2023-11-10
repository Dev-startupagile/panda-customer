
import 'package:flutter/material.dart';

import '../../../../../util/ui_constant.dart';

Widget customServiceListTile(leadingicon, text,trailingicon,listTilePressed) => Material(
    color: Colors.white,
    child: ListTile(
      leading:  Icon(leadingicon) ,
      title : Center(child: Text(text,style: KHintTextStyle,)),
      onTap: (){
        listTilePressed();
      },
      trailing: Icon(trailingicon),
    )

);