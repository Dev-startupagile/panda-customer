import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../commonComponents/buttons/main_button.dart';
import '../../../commonComponents/skeletal/custom_card_skeletal.dart';
import '../../../provider/estimate_provider.dart';
import '../../../provider/notification_provider.dart';
import '../../../provider/service_request_provider.dart';
import '../../../util/ui_constant.dart';
import '../history/historyComponent/history_list_tile.dart';

class RequestOffer extends StatefulWidget {
  final String requestId;
  const RequestOffer({Key? key, required this.requestId}) : super(key: key);

  @override
  State<RequestOffer> createState() => _RequestOfferState();
}

class _RequestOfferState extends State<RequestOffer> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context
        .read<ServiceRequestProvider>()
        .getRequestById(context, widget.requestId));
  }

  void decline() async {
    // print(widget.requestId);
    await context
        .read<ServiceRequestProvider>()
        .cancelServiceRequest(context, widget.requestId);
    context.read<NotificationProvider>().updateRequestOffer();
  }

  void accept() async {
    await context
        .read<ServiceRequestProvider>()
        .acceptServiceRequest(context, widget.requestId);
    context.read<NotificationProvider>().updateRequestOffer();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // height: 400,
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Card(
            child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: const Text(
              "Request Detail",
              style: KAppTitleTextStyle,
            ),
            subtitle: Row(
              children: [
                const Icon(
                  Icons.circle,
                  color: kPrimaryColorSecondary,
                ),
                Text(
                  "Technician Re Schedule Request",
                  style: KLatoRegularTextStyle,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Consumer<ServiceRequestProvider>(builder: (context, value, child) {
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
                      customRequestList("Service Type",
                          value.requestDetail?.description.title),

                      customRequestList("Service Description",
                          value.requestDetail?.description.note ?? ""),

                      const SizedBox(
                        height: 20,
                      ),

                      mainButton("ACCEPT", accept, kPrimaryColor),
                      mainButton("DECLINE", decline, kErrorColor),
                      // mainButton("RE-REQUEST", rerequest, kPrimaryColor)
                    ],
                  );
          }),
        ])),
      ),
    ));
  }
}
