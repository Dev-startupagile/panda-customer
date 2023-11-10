import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:panda/provider/rating_provider.dart';
import 'package:provider/provider.dart';
import '../../../commonComponents/buttons/main_button.dart';
import '../../../commonComponents/skeletal/custom_card_skeletal.dart';
import '../../../provider/estimate_provider.dart';
import '../../../provider/notification_provider.dart';
import '../../../provider/service_request_provider.dart';
import '../../../util/ui_constant.dart';
import '../history/historyComponent/history_list_tile.dart';


class RatingScreen extends StatefulWidget {
  String requestId;
  RatingScreen({Key? key, required this.requestId  }) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final ScrollController _scrollController = ScrollController();
  String feedBack = "";
  double ratingVal = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => {
      context.read<ServiceRequestProvider>().getRequestById(context, widget.requestId)
    });
    print("wasghf ${widget.requestId}");

  }

  void sendRating(){

    context.read<RatingProvider>().sendRating(
        context,
        context.read<ServiceRequestProvider>().requestDetail?.technicianInfo.id ?? "",
        ratingVal,
        widget.requestId,
        feedBack
    );

    context.read<RatingProvider>().updateRating();

  }

  @override
  Widget build(BuildContext context) {


    return SizedBox(
      // height: 400,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Card(
                child: Column(
                    children: [


                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        title: const Text("Rating", style: KAppTitleTextStyle,),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.circle,color: kPrimaryColorSecondary,),
                            Text("give us rating",style: KLatoRegularTextStyle,)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Consumer<ServiceRequestProvider>(
                          builder: (context,value,child) {


                            return value.isLoading ?

                            ListView.builder(
                                itemCount: 7,
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemBuilder: (context,index){
                                  return const CustomCardSkeletal();
                                }
                            )
                                :
                            ListView.builder(
                                itemCount: 1,
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemBuilder: (context,index){
                                  final req = value.requestDetail;
                                  return  Column(
                                    children: [

                                      Text(
                                        "Service Complete",
                                        style: TextStyle(fontSize: 17, color: Colors.green[400]),
                                      ),
                                      RatingBar.builder(
                                        initialRating: 5,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            ratingVal = rating;
                                          });
                                          print(rating);
                                        },
                                      ),
                                      Container(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          height: 120,
                                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 2,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: TextField(
                                            onChanged: ((value) {
                                              setState(() {
                                                feedBack = value;
                                              });
                                            }),
                                            expands: true,
                                            maxLength: 250,
                                            minLines: null,
                                            maxLines: null,
                                            style: const TextStyle(
                                                fontSize: 16, color: Colors.black),
                                            cursorWidth: 1,
                                            decoration: const InputDecoration(
                                              contentPadding:
                                               EdgeInsets.fromLTRB(10, 0, 0, 0),
                                              border: InputBorder.none,
                                              hintText: "Anything to say?",
                                            ),
                                          )),

                                      mainButton("Send Feedback", sendRating, kPrimaryColor)

                                    ],
                                  );

                                }
                            );

                          }

                      ),

                    ]
                )
            ),
          ),
        )
    );
  }
}
