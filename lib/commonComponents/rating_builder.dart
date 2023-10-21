import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Widget customRating(double initialRating,double minRating)=>RatingBar.builder(
  initialRating: initialRating,
  minRating: minRating,
  direction: Axis.horizontal,
  allowHalfRating: true,
  itemCount: 1,
  itemSize: 50.0,
  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
  itemBuilder: (context, _) => Row(
    children: const [
      Icon(
        Icons.star,
        color: Colors.black54,
        size: 24,
      ),
      Text("4.5"),

    ],
  ),
  onRatingUpdate: (rating) {
    // print(rating);
  },
);
