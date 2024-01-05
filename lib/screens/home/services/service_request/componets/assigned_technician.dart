import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panda/commonComponents/popup_dialog.dart';
import 'package:panda/commonComponents/profile_avatar.dart';
import 'package:panda/function/launcher.dart';
import 'package:panda/models/add_service_request_model.dart';
import 'package:panda/models/nearby_model.dart';

import '../../../../../util/ui_constant.dart';

class AssignedTechnician extends StatelessWidget {
  const AssignedTechnician({Key? key, required this.arg}) : super(key: key);
  final Map<String, dynamic> arg;
  @override
  Widget build(BuildContext context) {
    AddServiceRequestModel addServiceRequestModel = arg["service"];
    Datum mechanicProfile = arg["data"];
    DateTime dateTime = DateTime.parse(addServiceRequestModel.date!);

    return Card(
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              leading: profileAvatar(
                  mechanicProfile.technicianDetail?.profilePicture, null, true),
              title: Text(
                mechanicProfile
                        .technicianDetail?.fullName.capitalizeMaybeNull ??
                    "",
                style: KAppTitleTextStyle,
              ),
              subtitle: Text(
                mechanicProfile.technicianDetail?.id ?? "",
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                  onPressed: () {
                    if (mechanicProfile.technicianDetail?.phoneNumber == null) {
                      return showInfoDialog(
                          context,
                          "Sorry you can't call the technician at this time.",
                          () => null);
                    }
                    launchPhone(mechanicProfile.technicianDetail!.phoneNumber!);
                  },
                  icon: const Icon(Icons.phone))),
          const Divider(),
          ListTile(
            title: Text(
              addServiceRequestModel.serviceType!,
              style: KLatoRegularTextStyle.copyWith(
                  fontWeight: FontWeight.w700, color: Colors.black),
            ),
            subtitle: Row(
              children: [
                const Icon(
                  Icons.circle,
                  color: kPrimaryColorSecondary,
                ),
                Text(
                  "Technician Assigned",
                  style: KLatoRegularTextStyle,
                )
              ],
            ),
            trailing: Column(
              children: [
                Text(
                  addServiceRequestModel.title!,
                  style: KLatoRegularTextStyle,
                ),
                Text(
                  DateFormat('MM/dd/yyyy').format(dateTime),
                  style: KLatoRegularTextStyle,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
