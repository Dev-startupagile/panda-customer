import 'package:flutter/material.dart';
import 'package:panda/util/ui_constant.dart';

class RequestServiceScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  const RequestServiceScaffold(
      {Key? key, required this.child, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: KProfilePicAppBarTextStyle,
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: KPColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: const EdgeInsets.only(top: 40),
                child: child)));
  }
}
