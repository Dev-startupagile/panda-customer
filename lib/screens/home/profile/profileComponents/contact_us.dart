import 'package:flutter/material.dart';
import 'package:panda/models/contact_us_model.dart';
import 'package:panda/provider/contactus_provider.dart';
import 'package:panda/screens/home/profile/profileComponents/profile_textfield.dart';
import 'package:provider/provider.dart';

import '../../../../provider/profile_provider.dart';
import '../../../../util/ui_constant.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  submitData() {
    if (_formKey.currentState!.validate()) {
      AddContactUsModel addContactUsModel = AddContactUsModel(
          from: context
                  .read<ProfileProvider>()
                  .customerprofile
                  ?.personalInformation
                  .id ??
              "",
          subject: _subjectController.text,
          message: _messageController.text);

      context.read<ContactUsProvider>().contactUs(context, addContactUsModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Conatct Us',
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: width,
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, width * 0.05, width * 0.05, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.02, horizontal: width * 0.02),
                    child: const Text(
                      'Contact Us',
                      style: KAppBodyTextStyle,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.02, horizontal: width * 0.02),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          customContactUsTextField(
                              Icons.contact_page,
                              false,
                              "text",
                              _subjectController,
                              "Subject",
                              context,
                              submitData),
                          SizedBox(height: height * 0.03),
                          customContactUsTextField(
                              Icons.contact_page,
                              true,
                              "text",
                              _messageController,
                              "Message",
                              context,
                              submitData),
                          MaterialButton(
                              onPressed: () {
                                submitData();
                              },
                              height: 40,
                              minWidth: double.infinity,
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child:
                                  const Text("Send", style: KWhiteTextStyle)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
