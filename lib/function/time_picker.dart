import 'package:flutter/material.dart';
import 'package:panda/util/ui_constant.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

Future<DateTime?> pickDate(context, dateTime) => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: dateTime,
      lastDate: DateTime(dateTime.year + 1, dateTime.month, dateTime.day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: kPrimaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

Future<TimeOfDay?> pickTime(context, dateTime, day) => showCustomTimePicker(
    context: context,
    // It is a must if you provide selectableTimePredicate
    onFailValidation: (context) => print('Unavailable selection'),
    initialTime: TimeOfDay.now(),
    selectableTimePredicate: (time) {
      // if(day == dateTime.day){
      //   return time!.hour  >= ( 24 - TimeOfDay. now(). hour); //&& time.minute >= TimeOfDay.now().minute ;
      // }
      return true;
    },
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: kPrimaryColor, // header background color
            onPrimary: Colors.black, // header text color
            onSurface: Colors.black, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: kPrimaryColor, // button text color
            ),
          ),
        ),
        child: child!,
      );
    });
