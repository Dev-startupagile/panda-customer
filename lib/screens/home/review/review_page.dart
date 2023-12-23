import 'package:cached_network_image/cached_network_image.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:panda/commonComponents/popup_dialog.dart';
import 'package:panda/models/nearby_model.dart';
import 'package:panda/models/review_model.dart';
import 'package:panda/provider/rating_provider.dart';
import 'package:panda/util/ui_constant.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key, required this.technician}) : super(key: key);
  final Datum technician;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool isLoading = true;
  List<ReviewModel> reviews = [];
  Future<void> fetchReview() async {
    reviews = await context
        .read<RatingProvider>()
        .getReview(context, widget.technician.id);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteReview(String id) async {
    await context.read<RatingProvider>().deleteReview(context, id);
    // Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    fetchReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.technician.technicianDetail!.fullName} Reviews',
          style: KProfilePicAppBarTextStyle,
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: KPColor,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Text("Loading ..."),
                ],
              ),
            )
          : Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Overall Rating",
                      style: TextStyle(color: Color(0xffC0BFBD), fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.technician.technicianDetail!.rating
                          .toStringAsFixed(1),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 35,
                          letterSpacing: 2),
                    ),
                    const SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: widget.technician.technicianDetail!.rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      ignoreGestures: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Color(0xffE76F4F),
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Based on ${widget.technician.technicianDetail!.reviewCount} reviews",
                      style: const TextStyle(
                        color: Color(0xffC0BFBD),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
                const Divider(),
                if (reviews.isEmpty)
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("No reviews yet!"),
                  )),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        var review = reviews[index];
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.delete, color: Colors.white),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text('Remove Review',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          key: ValueKey<String>(index.toString()),
                          onDismissed: (DismissDirection direction) {
                            setState(() {
                              reviews.removeAt(index);
                            });
                          },
                          confirmDismiss: (DismissDirection direction) async {
                            if (direction == DismissDirection.endToStart) {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Remove Review"),
                                    content: const Text(
                                        "Are you sure you want to remove this review?"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          onPressed: () =>
                                              deleteReview(review.id),
                                          child: const Text("Yes")),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("No"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: CachedNetworkImage(
                                      imageUrl: review.userData!.profilePicture,
                                      fit: BoxFit.fill,
                                      height: 50,
                                      width: 50,
                                      placeholder: (context, url) =>
                                          const Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            color: kPrimaryColor),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset("assets/avater.png"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text(
                                          review.userData!.fullName.capitalize,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(height: 5),
                                        RatingBar.builder(
                                          itemSize: 10,
                                          initialRating:
                                              review.rating.toDouble(),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          ignoreGestures: true,
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 1.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Color(0xffE76F4F),
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                        const SizedBox(height: 5),
                                        Text(review.review),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Date / ${DateFormat('MMMM dd, yyyy').format(review.createdAt)}",
                                          style: const TextStyle(
                                            color: Color(0xffC0BFBD),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ]))
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Divider(),
                              const SizedBox(height: 10),
                            ]),
                          ),
                        );
                      }),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          showReviewPopup(
              context,
              widget.technician.technicianDetail!.fullName!,
              widget.technician.technicianDetail!.id!,
              null, (review) {
            setState(() {
              reviews.add(review);
              widget.technician.technicianDetail!.rating =
                  (widget.technician.technicianDetail!.reviewCount *
                              widget.technician.technicianDetail!.rating +
                          review.rating) /
                      (widget.technician.technicianDetail!.reviewCount + 1);
              widget.technician.technicianDetail!.reviewCount++;
            });
          });
        },
        label: const Row(
          children: [Icon(Icons.add), Text("Review")],
        ),
      ),
    );
  }
}
