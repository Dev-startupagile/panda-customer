import 'package:flutter/material.dart';
import 'package:panda/models/nearby_model.dart';
import 'package:panda/screens/home/review/review_page.dart';

Widget customRating(
        BuildContext context, double value, int reviewCount, Datum datum) =>
    GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReviewPage(
                  technician: datum,
                )));
      },
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.black54,
                size: 24,
              ),
              Text(value.toStringAsFixed(1)),
            ],
          ),
          Text("$reviewCount reviews")
        ],
      ),
    );
