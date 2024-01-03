import 'package:flutter/material.dart';
import 'package:panda/commonComponents/popup_dialog.dart';
import 'package:panda/commonComponents/profile_avatar.dart';
import 'package:panda/util/ui_constant.dart';

import '../../../../../commonComponents/buttons/main_button.dart';
import '../../../../../commonComponents/rating_builder.dart';
import '../../../../../function/launcher.dart';
import '../../../../../models/nearby_model.dart';

class MechanicsProfile extends StatelessWidget {
  final dynamic getFunc;
  final Datum? mechanicProfile;
  final dynamic sendServiceRequest;
  const MechanicsProfile(
      {required this.mechanicProfile,
      this.sendServiceRequest,
      this.getFunc,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void assignTechnician() {
      sendServiceRequest(mechanicProfile?.id);
    }

    return Card(
      elevation: 1,
      child: Column(
        children: [
          ListTile(
              leading: profileAvatar(
                  mechanicProfile?.technicianDetail?.profilePicture,
                  null,
                  true),
              title: Text(mechanicProfile?.technicianDetail?.fullName ?? ""),
              subtitle: Text(mechanicProfile?.technicianDetail?.id ?? ""),
              trailing: IconButton(
                  onPressed: () {
                    if (mechanicProfile?.technicianDetail?.phoneNumber ==
                        null) {
                      return showInfoDialog(
                          context,
                          "Sorry you can't call the technician at this time.",
                          () => null);
                    }
                    launchPhone(
                        mechanicProfile!.technicianDetail!.phoneNumber!);
                  },
                  icon: const Icon(Icons.phone))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: customRating(
                    context,
                    mechanicProfile!.technicianDetail!.rating,
                    mechanicProfile!.technicianDetail!.reviewCount,
                    mechanicProfile!),
              ),
              Text(
                mechanicProfile!.distance![0] == "0"
                    ? "O Mile"
                    : '${mechanicProfile!.distance!.substring(0, 4)} Mile',
                style: KLatoRegularTextStyle,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      if (mechanicProfile?.technicianDetail?.phoneNumber ==
                          null) {
                        return showInfoDialog(
                            context,
                            "Sorry you can't text the technician at this time.",
                            () => null);
                      }
                      launchSms(
                          mechanicProfile!.technicianDetail!.phoneNumber!);
                    },
                    icon: const Icon(Icons.message, color: Colors.grey)),
              ),
            ],
          ),
          mainButton("Assign Technician", assignTechnician, kPrimaryColor),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
