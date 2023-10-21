import 'package:flutter/material.dart';

class AssistanceForm extends StatelessWidget {
  String assistanceType;
  final dynamic getFunc;

  AssistanceForm({required this.assistanceType,this.getFunc,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        const Center(
          child: Text(
              "Towing, tire change and emergency gas fillup service"),
        ),
        Card(
          child: RadioListTile(
            title: const Text(
              "I need my Vehicle towed",
            ),
            contentPadding: const EdgeInsets.all(5),
            activeColor: Colors.blue,
            value: "I need my Vehicle towed",
            groupValue: assistanceType,
            onChanged: (value) {
              getFunc(value.toString());
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          child: RadioListTile(
            title: const Text(
              "I need a tire changed",
            ),
            contentPadding: const EdgeInsets.all(5),
            activeColor: Colors.blue,
            value: "I need a tire changed",
            groupValue: assistanceType,
            onChanged: (value) {
              getFunc(value.toString());
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          child: RadioListTile(
            title: const Text(
              "I need gas",
            ),
            contentPadding: const EdgeInsets.all(5),
            activeColor: Colors.blue,
            value: "I need gas",
            groupValue: assistanceType,
            onChanged: (value) {
              getFunc(value.toString());
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          child: RadioListTile(
            title: const Text(
              "I am locked out of my vehicle",
            ),
            contentPadding: const EdgeInsets.all(5),
            activeColor: Colors.blue,
            value: "I am locked out of my vehicle",
            groupValue: assistanceType,
            onChanged: (value) {
              getFunc(value.toString());
            },
          ),
        ),
      ],
    );
  }
}
