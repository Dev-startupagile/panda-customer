import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:panda/commonComponents/popup_dialog.dart';
import 'package:panda/commonComponents/profile_avatar.dart';
import 'package:panda/function/substring.dart';
import 'package:panda/provider/auth_provider.dart';
import 'package:panda/screens/home/profile/profileComponents/list_tile.dart';
import 'package:panda/screens/home/profile/profileComponents/payment_detail.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../commonComponents/skeletal/custom_profile_skeletal.dart';
import '../../../provider/profile_provider.dart';
import '../../../util/ui_constant.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    yesLogout() {
      context.read<AuthProvider>().signOut(context);
    }

    void logout() {
      showPopupDialog(context, "Logout", height, width, yesLogout);
    }

    void paymentMethod() {
      print("Payemnt");
    }

    void deleteVehicle(id) {
      context.read<ProfileProvider>().removeVehicle(context, id);
    }

    void editProfile() {
      Navigator.pushNamed(context, "/edit_profile");
    }

    void addVehicle() {
      Navigator.pushNamed(context, "/add_vehicle");
    }

    void addPayment() {
      Navigator.pushNamed(context, "/add_payment");
    }

    void cardDetail(req) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentDetail(tokenizedCard: req)),
      );
    }

    void termOfservices() async {
      // Navigator.pushNamed(context, "/term_of_services");
      await launchUrl(Uri.parse("https://www.panda-mars.com/terms"));
    }

    void privacyPolicy() async {
      // Navigator.pushNamed(context, "/privacy_policy");
      await launchUrl(Uri.parse("https://www.panda-mars.com/privacy"));
    }

    void settings() {
      Navigator.pushNamed(context, "/settings");
    }

    void contactUs() {
      Navigator.pushNamed(context, "/contact_us");
    }

    void help() {
      Navigator.pushNamed(context, "/help");
    }

    void faq() {
      Navigator.pushNamed(context, "/faq");
    }

    return Scaffold(body: SingleChildScrollView(
        child: Consumer<ProfileProvider>(builder: (context, value, child) {
      return value.isLoading || value.customerprofile == null
          ? const CustomProfileSkeletal()
          : Padding(
              padding: EdgeInsets.fromLTRB(
                  height * 0.01, height * 0.05, height * 0.01, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 1.0,
                    shadowColor: kPrimaryColor,
                    color: KBGColor,
                    child: ListTile(
                      leading: profileAvatar(
                          value.customerprofile?.personalInformation
                              .profilePicture,
                          null,
                          true),
                      title: Text(
                        value.customerprofile?.personalInformation.fullName ??
                            "",
                        textScaleFactor: 1.1,
                      ),
                      subtitle: Text(
                          value.customerprofile?.personalInformation.id ?? ""),
                      trailing: TextButton(
                        onPressed: () {
                          editProfile();
                        },
                        child: const Text(
                          "Edit",
                          style: KAppEditTextStyle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  const Text(
                    "Vehicle",
                    style: KAppTitleTextStyle,
                  ),
                  value.customerprofile!.vehicles.items.isEmpty
                      ? const Center(
                          child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "no vehicle",
                            style: TextStyle(fontSize: 16),
                          ),
                        ))
                      : SizedBox(
                          height: height * 0.33,
                          child: ListView.builder(
                              itemCount:
                                  value.customerprofile?.vehicles.items.length,
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: height * 0.01),
                                    width: width * 0.65,
                                    child: Card(
                                      elevation: 1.0,
                                      shadowColor: kPrimaryColor,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment:
                                                  AlignmentDirectional.topEnd,
                                              child: IconButton(
                                                  onPressed: () {
                                                    deleteVehicle(value
                                                        .customerprofile
                                                        ?.vehicles
                                                        .items[index]
                                                        .id);
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  )),
                                            ),
                                            vehicleAvatar(
                                                true,
                                                value.customerprofile?.vehicles
                                                        .items[index].image ??
                                                    "",
                                                null),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${value.customerprofile?.vehicles.items[index].brand}' ??
                                                              "",
                                                          style: KLatoTextStyle,
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          value
                                                                  .customerprofile
                                                                  ?.vehicles
                                                                  .items[index]
                                                                  .description ??
                                                              "",
                                                          style:
                                                              KLatoRegularTextStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Icon(Icons.square_rounded,
                                                    size: 30,
                                                    color: Color(int.parse(
                                                        "0xff${value.customerprofile?.vehicles.items[index].color}")))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              }),
                        ),
                  Row(
                    children: [
                      const Icon(
                        Icons.add,
                        color: kPrimaryColor,
                      ),
                      TextButton(
                        onPressed: () {
                          addVehicle();
                        },
                        child: const Text(
                          'ADD NEW VEHICLE',
                          style: AdditemTextStyle,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Payment",
                    style: KAppTitleTextStyle,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  value.customerprofile!.payments.items.isEmpty
                      ? const Center(
                          child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "no payment card",
                            style: TextStyle(fontSize: 16),
                          ),
                        ))
                      : ListView.builder(
                          itemCount:
                              value.customerprofile?.payments.items.length,
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: customListTile(
                                  Icons.credit_card_rounded,
                                  value.customerprofile?.payments.items[index]
                                      .hiddenCN,
                                  Icons.arrow_forward_ios_sharp,
                                  cardDetail,
                                  value.customerprofile?.payments.items[index]),
                            );
                          }),
                  Row(
                    children: [
                      const Icon(
                        Icons.add,
                        color: kPrimaryColor,
                      ),
                      TextButton(
                        onPressed: () {
                          addPayment();
                        },
                        child: const Text(
                          'ADD NEW PAYMENT METHOD',
                          style: AdditemTextStyle,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "More",
                    style: KAppTitleTextStyle,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  customListTile(Icons.note_add, "Term of Services",
                      Icons.arrow_forward_ios_sharp, termOfservices, null),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  customListTile(Icons.privacy_tip, "Privacy Policy",
                      Icons.arrow_forward_ios_sharp, privacyPolicy, null),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  customListTile(Icons.help, "Help",
                      Icons.arrow_forward_ios_sharp, help, null),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  customListTile(Icons.question_mark, "FAQ",
                      Icons.arrow_forward_ios_sharp, faq, null),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  customListTile(Icons.contact_support, "Contact Us",
                      Icons.arrow_forward_ios_sharp, contactUs, null),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  customListTile(Icons.settings, "Settings",
                      Icons.arrow_forward_ios_sharp, settings, null),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  customListTile(Icons.logout, "Logout",
                      Icons.arrow_forward_ios_sharp, logout, null),
                  SizedBox(
                    height: height * 0.04,
                  ),
                ],
              ),
            );
    })));
  }
}
