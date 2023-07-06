
import 'package:flutter/material.dart';

import '../../../../util/ui_constant.dart';

Widget customListTile(leadingicon, text,trailingicon,listTilePressed,data) => Material(
  elevation: 0.5,
  shadowColor: kPrimaryColor,
  color: KBGColor,
  child: ListTile(
    leading: Icon(leadingicon),
    title : Text(text,style: KHintTextStyle,),

    onTap: (){
      if(data == null){
        listTilePressed();
      }else{
        listTilePressed(data);
      }
    },
    trailing: Icon(trailingicon),
  )

);



Widget customEditProfile(title,subtitle,submitData)=>Padding(
  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
  child: SizedBox(
    height: 60,
    child: Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,style: KAppBodyTextStyle),
            Text(subtitle,style: KHintTextStyle),
            IconButton(
                onPressed: (){
                  submitData(title,subtitle);
                },
                icon: const Icon(Icons.edit)
            )
          ],
        ),
      ),
    ),
  ),
);