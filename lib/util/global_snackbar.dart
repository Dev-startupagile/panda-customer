import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

AnimationController? localAnimationController;

void displayInfoSnackBar(BuildContext context, String text){
  AnimatedSnackBar.material(
    text ,
    type: AnimatedSnackBarType.info,
  ).show(context);

}

void displayErrorSnackBar(BuildContext context, String text){
  AnimatedSnackBar.material(
    text ,
    type: AnimatedSnackBarType.error,
  ).show(context);
}

void displaySuccessSnackBar(BuildContext context, String text){
  AnimatedSnackBar.material(
    text ,
    type: AnimatedSnackBarType.success,
  ).show(context);

}
