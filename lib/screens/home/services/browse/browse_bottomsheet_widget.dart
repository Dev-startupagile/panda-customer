import 'package:flutter/material.dart';
import 'package:panda/screens/home/services/browse/components/search_textfield.dart';
import 'package:provider/provider.dart';

import '../../../../commonComponents/rating_builder.dart';
import '../../../../commonComponents/skeletal/custom_card_skeletal.dart';
import '../../../../provider/nearby_provider.dart';
import 'components/mechanics_profile.dart';

class Browse extends StatefulWidget {
  final dynamic getFunc;
  final double longitude;
  final double latitude;

  const Browse(
      {required this.latitude, required this.longitude, this.getFunc, Key? key})
      : super(key: key);

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  bool isDetail = false;
  late TextEditingController searchController;
  final ScrollController _scrollController = ScrollController();

  void openCloseDetail(email) {
    setState(() {
      isDetail = !isDetail;
    });
  }

  void closeDetail() {
    setState(() {
      isDetail = !isDetail;
    });
  }

  void searchMechanic(String value) {
    print("hallo, $value");
  }

  @override
  void initState() {
    searchController = TextEditingController();
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   context.read<NearByProvider>().nearBy(context, widget.latitude, widget.longitude);
    // });
  }

  @override
  void dispose() {
    searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: height * 0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 45,
                    ),
                    color: Colors.black54,
                    onPressed: () {
                      isDetail ? closeDetail() : widget.getFunc();
                    },
                  ),
                  Text(
                    isDetail ? "Best Mechanics Ever" : "Browse",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customSearchTextField(
                        searchController, "Search", context, searchMechanic),
                  ),
                  Consumer<NearByProvider>(builder: (context, value, child) {
                    return value.nearby.isEmpty && value.isLoaded
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child:
                                  Center(child: Text('no Nearby technicians')),
                            )),
                          )
                        : value.isLoading
                            ? ListView.builder(
                                itemCount: 7,
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemBuilder: (context, index) {
                                  return const CustomCardSkeletal();
                                })
                            : ListView.builder(
                                itemCount: value.nearby.length,
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemBuilder: (context, index) {
                                  final req = value.nearby[index];
                                  return isDetail == true
                                      ? MechanicsProfile(
                                          mechanicProfile: req,
                                          getFunc: openCloseDetail)
                                      : Card(
                                          elevation: 1,
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: const CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      Colors.greenAccent,
                                                  child: CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/profile_placeholder.png'),
                                                    radius: 24,
                                                  ),
                                                ),
                                                title: Text(req.technicianDetail
                                                        ?.fullName ??
                                                    ""),
                                                subtitle: Text(
                                                    req.technicianDetail?.id ??
                                                        ""),
                                                trailing: const Icon(
                                                  Icons.chevron_right,
                                                  size: 50,
                                                ),
                                                onTap: () {
                                                  openCloseDetail(req.id);
                                                },
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  customRating(
                                                      context,
                                                      req.technicianDetail!
                                                          .rating,
                                                      req.technicianDetail!
                                                          .reviewCount,
                                                      req)
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        );
                                },
                              );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
