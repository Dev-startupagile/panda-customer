import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_cvc_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_expiration_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_number_input_formatter.dart';

class CustomCardTextField extends StatefulWidget {
  bool isExpr;
  bool isCvc;
  TextEditingController nameController;
  bool isCardNumber;
  bool isCardValid;
  String title;
  Function actionValidator;

  CustomCardTextField({
    required this.nameController,
    required this.isExpr,
    required this.isCvc,
    required this.isCardNumber,

    required this.title,
    required this.isCardValid,
    required this.actionValidator,


    Key? key}) : super(key: key);

  @override
  State<CustomCardTextField> createState() => _CustomCardTextFieldState();
}

class _CustomCardTextFieldState extends State<CustomCardTextField> {


  boxShadowColor(){
    if( !widget.isCardValid ){
      return Colors.red;
    }else{
      return Colors.grey.withOpacity(0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color:boxShadowColor(),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller:  widget.nameController,
            cursorColor: Colors.blueGrey,
            textInputAction: TextInputAction.go,

            inputFormatters: [
              widget.isCardNumber?
              CreditCardNumberInputFormatter():
                  widget.isExpr?
              CreditCardExpirationDateFormatter():
              CreditCardCvcInputFormatter(isAmericanExpress: true)
            ],
            onChanged: (value){
              if(widget.isExpr){
                setState((){
                  widget.isCardValid = widget.actionValidator(value);
                });
              }else if(widget.isCvc){
                setState((){
                  widget.isCardValid = widget.actionValidator(value);
                });
              }else if(widget.isCardNumber){
                setState((){
                  widget.isCardValid = widget.actionValidator(value);
                });
              }

            },
            style: const TextStyle(fontSize: 16),
            cursorWidth: 1,
            decoration:  InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: widget.title,

            ),
          ),
        ),
      ),
    );
  }
}