import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../commonComponents/profile_avatar.dart';
import '../../../function/time_picker.dart';
import '../../../models/estimate_model.dart';
import '../../../provider/service_request_provider.dart';
import '../../../util/ui_constant.dart';
import '../services/service_request/componets/service_listtile.dart';

class ReSchedulePage extends StatefulWidget {
  final String title;
  final Function onClickNext;
  final Function onClickBack;
  final Function hideDetail;
  final Function refreshEstimate;

  final Function onClickClose;
  Datum estimateDetail;


   ReSchedulePage({
     required this.estimateDetail,
     required this.onClickClose,
    required this.title,
    required this.onClickNext,
     required this.hideDetail,
     required this.refreshEstimate,
     required this.onClickBack,
    Key? key}) : super(key: key);

  @override
  State<ReSchedulePage> createState() => _ReSchedulePageState();
}

class _ReSchedulePageState extends State<ReSchedulePage> {
  final ScrollController _scrollController = ScrollController();
  DateTime dateTime = DateTime.now();



  Future pickDateTime() async{
    DateTime? date = await pickDate(context,dateTime);
    if(date == null) return;
    TimeOfDay? time = await pickTime(context,dateTime,date.day);

    if(time == null) return;

    final newDateTime = DateTime
      (date.year,date.month,date.day,time.hour,time.minute);

    setState(() {
      dateTime = newDateTime;
    });

  }

  void timePressed(){
    pickDateTime();
  }

  void rerequest() async {
    await context.read<ServiceRequestProvider>()
        .reRequestService(
        context,
        widget.estimateDetail.requestId,
        dateTime.toString(),
        dateTime.toString()
    );
    widget.onClickClose();
    widget.hideDetail();
    widget.refreshEstimate();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: SizedBox(
        height:  height * 0.8,
        child: SingleChildScrollView(
          controller: _scrollController,
          child:Column(
            children: [

              Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      ElevatedButton(
                        onPressed: () {
                          widget.onClickBack();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                        ),
                        child: const Text('Back'),
                      ),

                    ElevatedButton(
                          onPressed: () {
                            rerequest();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(255, 48, 226, 152),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                          ),
                          child: const Text('Next') ,
                        ),
                    ],
                  ),
                ),

              const SizedBox(height: 15),

              Image.asset(
                  "lib/assets/rode-side.png",
                  height: 120,
                  width: 170,
                ),

              const SizedBox(height: 15),

              const Text("Schedule a Repair",style: KAppTitleTextStyle,),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Schedule a time for your repair, the technician let you know  if you need a schedule ",style: KLatoRegularTextStyle,),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                    elevation: 0.5,
                    shadowColor: kPrimaryColor,
                    color: Colors.white,
                    child:
                    customServiceListTile(null, DateFormat('MM/dd/yyyy hh:mm a').format(dateTime), Icons.arrow_forward_ios_sharp, timePressed)
                ),
              ),

              Column(
                      children: [
                      InkWell(
                      onTap: (){

                        },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        ListView.builder(
                          itemCount: widget.estimateDetail.vehiclesDetail.length,
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemBuilder: (context,index){
                            return  ListTile(
                              leading: vehicleAvatar(false,widget.estimateDetail.vehiclesDetail[index].image, null),
                              title: Text(widget.estimateDetail.vehiclesDetail[index].model ?? "",style: KLatoTextStyle,) ,
                              subtitle: Text(widget.estimateDetail.vehiclesDetail[index].model ?? "",style: KLatoRegularTextStyle,),
                              trailing: index == 0?  Text(
                                '\$${widget.estimateDetail.totalEstimation}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent),
                              ): null,
                            );
                          },
                        ),

                        ListTile(
                          title:  Text(widget.estimateDetail.title ?? "",style: KAppTitleTextStyle,),
                          subtitle:  Text(widget.estimateDetail.note ?? "",style: KHintTextStyle,),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        ],
                       ),
                       )
                      )
               ],
             )
           ]
          ),
        ),
      ),
    );
  }
}
