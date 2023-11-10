import 'package:flutter/material.dart';

Widget mainButton(buttonText,actionMethod,color)=> Padding(
  padding: const EdgeInsets.all(8.0),
  child:   SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        actionMethod();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
            horizontal: 55, vertical: 20),
      ),
      child:  Text(buttonText),
    ),
  ),
);

Widget elevatedButton(color,title,actionMethod)=>ElevatedButton(
  onPressed: () {
      actionMethod();
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: color,
    padding: const EdgeInsets.symmetric(
        horizontal: 10, vertical: 5),
  ),
  child:  Text(
    title,
  ),
);