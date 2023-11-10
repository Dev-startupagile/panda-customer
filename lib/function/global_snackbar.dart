import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

AnimationController? localAnimationController;

void displayInfoSnackBar(BuildContext context, String text){
  AnimatedSnackBar.material(
    text ,
    type: AnimatedSnackBarType.warning,
  ).show(context);

}

void displayErrorSnackBar(BuildContext context,String text) {
  showDialog(
      context: context,
      barrierDismissible: false, // disables popup to close if tapped outside popup (need a button to close)
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text,style: const TextStyle(color: Colors.red), ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                  Navigator.of(context).pop();
              }, //closes popup
            ),
          ],
        );
      }
  );
}

void displaySuccessSnackBar(BuildContext context, String text){
  AnimatedSnackBar.material(
    text ,
    type: AnimatedSnackBarType.success,
  ).show(context);

}
