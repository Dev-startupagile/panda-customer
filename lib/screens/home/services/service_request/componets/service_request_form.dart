import 'package:flutter/material.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:panda/models/add_service_request_model.dart';
import 'package:panda/provider/service_provider.dart';
import 'package:panda/provider/uploader_provider.dart';
import 'package:panda/screens/home/services/service_request/componets/request_service_btn.dart';
import 'package:panda/screens/home/services/service_request/componets/request_service_scaffold.dart';
import 'package:panda/screens/home/services/service_request/componets/where_are_you_form.dart';
import 'package:provider/provider.dart';

import '../../../../../commonComponents/skeletal/custom_card_skeletal.dart';
import '../../../../../util/ui_constant.dart';

class ServiceRequestFormPage extends StatefulWidget {
  final AddServiceRequestModel addServiceRequestModel;

  const ServiceRequestFormPage({required this.addServiceRequestModel, Key? key})
      : super(key: key);

  @override
  State<ServiceRequestFormPage> createState() => _ServiceRequestFormPageState();
}

class _ServiceRequestFormPageState extends State<ServiceRequestFormPage> {
  final ScrollController _scrollController = ScrollController();
  String? serviceType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceProvider>().getAllServices(context, false);
      context.read<UploaderProvider>().initialValue();
    });
    serviceType = widget.addServiceRequestModel.serviceType;
  }

  @override
  Widget build(BuildContext context) {
    return RequestServiceScaffold(
        title: "Service Request",
        child: Consumer<ServiceProvider>(builder: (context, value, child) {
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
                  : Column(
                      children: [
                        ListView.builder(
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        side: BorderSide(
                                            width: 2,
                                            color: Colors.lightBlueAccent))
                                    : null,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      serviceType = req.title;
                                    });
                                    widget.addServiceRequestModel.serviceId =
                                        req.id;
                                    widget.addServiceRequestModel.serviceType =
                                        serviceType;
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
                        ),
                        RequestServiceBtn(onTap: () {
                          if (widget.addServiceRequestModel.serviceId == null) {
                            return displayInfoSnackBar(
                                context, "please Select Service type");
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WhereAreYouPage(
                                        addServiceRequestModel:
                                            widget.addServiceRequestModel)));
                          }
                        }),
                      ],
                    );
        }));
  }
}
