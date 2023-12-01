import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:panda/models/review_model.dart';
import 'package:panda/provider/rating_provider.dart';
import 'package:provider/provider.dart';
import '../../../commonComponents/buttons/main_button.dart';
import '../../../util/ui_constant.dart';

class RatingWidget extends StatefulWidget {
  const RatingWidget(
      {Key? key, this.requestId, required this.to, required this.callback})
      : super(key: key);
  final String? requestId;
  final String to;
  final Function(ReviewModel) callback;
  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  String feedBack = "";
  double ratingVal = 5.0;

  @override
  void initState() {
    super.initState();
  }

  void sendRating() async {
    var response = await context
        .read<RatingProvider>()
        .sendRating(context, widget.to, ratingVal, widget.requestId, feedBack);

    context.read<RatingProvider>().updateRating();
    widget.callback(response!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBar.builder(
          initialRating: 5,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              ratingVal = rating;
            });
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
              style: const TextStyle(fontSize: 16, color: Colors.black),
              cursorWidth: 1,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                border: InputBorder.none,
                hintText: "Anything to say?",
              ),
            )),
        mainButton("Send Feedback", sendRating, kPrimaryColor)
      ],
    );
  }
}
