import 'package:flutter/material.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:panda/models/add_service_request_model.dart';
import 'package:panda/provider/service_request_provider.dart';
import 'package:panda/provider/uploader_provider.dart';
import 'package:panda/screens/home/services/service_request/componets/finding_ur_technician.dart';
import 'package:panda/screens/home/services/service_request/componets/payment_list_tile.dart';
import 'package:panda/screens/home/services/service_request/componets/request_service_btn.dart';
import 'package:panda/screens/home/services/service_request/componets/request_service_scaffold.dart';
import 'package:provider/provider.dart';

import '../../../../../commonComponents/skeletal/custom_profile_skeletal.dart';
import '../../../../../provider/profile_provider.dart';
import '../../../../../util/ui_constant.dart';
import '../../../profile/profileComponents/payment_detail.dart';

class SelectPaymentMethodPage extends StatefulWidget {
  final AddServiceRequestModel addServiceRequestModel;

  const SelectPaymentMethodPage(
      {Key? key, required this.addServiceRequestModel})
      : super(key: key);

  @override
  State<SelectPaymentMethodPage> createState() =>
      _SelectPaymentMethodPageState();
}

class _SelectPaymentMethodPageState extends State<SelectPaymentMethodPage> {
  String? paymentId;
  @override
  Widget build(BuildContext context) {
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

    return RequestServiceScaffold(
      title: "Select Payment Method",
      child: SingleChildScrollView(
          child: Consumer<ProfileProvider>(builder: (context, value, child) {
        return value.isLoading || value.customerprofile == null
            ? const CustomProfileSkeletal()
            : Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Your Payment Method",
                      style: KAppTitleTextStyle,
                    ),
                    const SizedBox(
                      height: 10,
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
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      paymentId = value.customerprofile
                                          ?.payments.items[index].id;
                                    });
                                  },
                                  child: Card(
                                    shape: paymentId ==
                                            value.customerprofile?.payments
                                                .items[index].id
                                        ? const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            side: BorderSide(
                                                width: 2, color: kPrimaryColor))
                                        : null,
                                    child: customListTile(
                                        Icons.credit_card_rounded,
                                        value.customerprofile?.payments
                                            .items[index].hiddenCN,
                                        Icons.arrow_forward_ios_sharp,
                                        cardDetail,
                                        value.customerprofile?.payments
                                            .items[index]),
                                  ),
                                ),
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
                    RequestServiceBtn(onTap: () async {
                      widget.addServiceRequestModel.paymentId = paymentId;
                      if (widget.addServiceRequestModel.paymentId == null) {
                        return displayInfoSnackBar(
                            context, "please select payment method first!");
                      }
                      var response = await context
                          .read<ServiceRequestProvider>()
                          .sendServiceRequest(
                              context,
                              widget.addServiceRequestModel,
                              context.read<UploaderProvider>().uploadedFileList,
                              widget.addServiceRequestModel.vehicleId);
                      if (response?.statusCode != 201) {
                        return;
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FindingYourTechnician(
                                  addServiceRequestModel:
                                      widget.addServiceRequestModel)));
                    })
                  ],
                ),
              );
      })),
    );
  }
}
