import 'package:flutter/material.dart';

class RequestServiceBtn extends StatelessWidget {
  final String title;
  final Function() onTap;
  const RequestServiceBtn({
    super.key,
    required this.onTap,
    this.title = "Next",
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(255, 48, 226, 152),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      ),
      child: SizedBox(
          width: double.maxFinite,
          child: Center(
              child: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ))),
    );
  }
}
