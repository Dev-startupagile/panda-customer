import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda/provider/service_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../commonComponents/skeletal/custom_card_skeletal.dart';
import '../../../../../util/ui_constant.dart';

class serviceRequestForm extends StatelessWidget {
  String serviceType;
  final dynamic getFunc;
  final dynamic setServiceId;

  serviceRequestForm(
      {required this.setServiceId,
      required this.serviceType,
      this.getFunc,
      Key? key})
      : super(key: key);
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<ServiceProvider>(builder: (context, value, child) {
            return value.services.isEmpty && value.isLoaded
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text('no Service Request')),
                    )),
                  )
                : value.isLoading
                    ? ListView.builder(
                        itemCount: 3,
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return const CustomCardSkeletal();
                        })
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: value.services.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final req = value.services[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: serviceType == req.title
                                  ? const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      side: BorderSide(
                                          width: 2,
                                          color: Colors.lightBlueAccent))
                                  : null,
                              child: InkWell(
                                onTap: () {
                                  getFunc(value.toString());
                                  setServiceId(req.id);
                                },
                                child: ListTile(
                                  title: Text(
                                    req.title,
                                    style: KLatoTextStyle,
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  // activeColor: Colors.lightBlueAccent,
                                  // isThreeLine: true,
                                  subtitle: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          req.description,
                                          style: KLatoRegularTextStyle,
                                        ),
                                      ),
                                      Image.asset("assets/mechanic.png"),
                                    ],
                                  ),
                                  // value: req.title,
                                  // groupValue: serviceType,
                                  // onChanged: (value) {
                                  //   getFunc(value.toString());
                                  //   setServiceId(req.id);
                                  // },
                                ),
                              ),
                            ),
                          );
                        },
                      );
          }),
        ],
      ),
    );
  }
}
