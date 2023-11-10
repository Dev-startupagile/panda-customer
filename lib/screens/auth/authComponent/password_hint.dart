

import 'package:flutter/material.dart';

import '../../../function/validation/validationService.dart';

Widget passwordHint(passwordController)=> Column(
  children: [
    passwordController.isNotEmpty
        ? Container(
      width: 340,
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Icon(
              color: is8Char(passwordController)
                  ? Colors.green[400]
                  : Colors.grey[600],
              Icons.circle,
              size: 11,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
                style: TextStyle(
                    color: Colors.grey[600], fontSize: 11),
                "Minimem 8 charachters")
          ]),
          const SizedBox(
            width: 5,
          ),
          Row(children: <Widget>[
            Icon(
              color: containsNumb(passwordController)
                  ? Colors.green[400]
                  : Colors.grey[600],
              Icons.circle,
              size: 11,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
                style: TextStyle(
                    color: Colors.grey[600], fontSize: 11),
                "Numbers[0-9]")
          ]),
        ],
      ),
    )
        : const SizedBox(),
    (( passwordController.isNotEmpty)
        ? Container(
      width: 340,
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Icon(
              color: containsLowerCase(passwordController)
                  ? Colors.green[400]
                  : Colors.grey[600],
              Icons.circle,
              size: 11,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
                style: TextStyle(
                    color: Colors.grey[600], fontSize: 11),
                "LowerCase Letters[a-z]")
          ]),
          const SizedBox(
            width: 10,
          ),
          Row(children: <Widget>[
            Icon(
              color: containsUpperCase(passwordController)
                  ? Colors.green[400]
                  : Colors.grey[600],
              Icons.circle,
              size: 11,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
                style: TextStyle(
                    color: Colors.grey[600], fontSize: 11),
                "UpperCase Letters[A-Z]")
          ]),
        ],
      ),
    )
        : const SizedBox()),
    ((passwordController.isNotEmpty)
        ? Container(
      width: 340,
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Icon(
              color: containsSymbols(passwordController)
                  ? Colors.green[400]
                  : Colors.grey[600],
              Icons.circle,
              size: 11,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
                style: TextStyle(
                    color: Colors.grey[600], fontSize: 11),
                "Symbols")
          ]),
        ],
      ),
    )
        : const SizedBox()),
  ],
);