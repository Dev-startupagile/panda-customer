import 'package:flutter/material.dart';
import 'package:panda/screens/home/services/browse/components/mechanics_profile.dart';
import 'package:provider/provider.dart';
import '../../../../../commonComponents/skeletal/custom_card_skeletal.dart';
import '../../../../../provider/nearby_provider.dart';
import '../../../../../util/ui_constant.dart';

class FindingYourTechnician extends StatefulWidget {
  final double longitude;
  final double latitude;
  final Function cancelServiceRequest;
  final Function sendServiceRequest;
  final Function noNearBy;
  const FindingYourTechnician(
      {required this.noNearBy,
      required this.sendServiceRequest,
      required this.cancelServiceRequest,
      required this.longitude,
      required this.latitude,
      Key? key})
      : super(key: key);

  @override
  State<FindingYourTechnician> createState() => _FindingYourTechnicianState();
}

class _FindingYourTechnicianState extends State<FindingYourTechnician> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NearByProvider>().nearBy(
          context, widget.latitude, widget.longitude, backToHome, false);
    });
  }

  void cancelServiceRequest() {
    widget.cancelServiceRequest();
  }

  void backToHome() {
    widget.noNearBy();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<NearByProvider>(builder: (context, value, child) {
          return value.isLoading
              ? ListView.builder(
                  itemCount: 7,
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return const CustomCardSkeletal();
                  })
              : Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 25,
                              color: kPrimaryColor,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Nearby technicians",
                              style: KAppTitleTextStyle,
                            )
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: value.nearby.length,
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        final req = value.nearby[index];

                        return MechanicsProfile(
                            mechanicProfile: req,
                            sendServiceRequest: widget.sendServiceRequest);
                      },
                    ),
                  ],
                );
        }),
      ],
    );
  }
}
