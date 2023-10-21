import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:panda/util/ui_constant.dart';

Widget profileAvatar(
  profileUrl,
  image,
  bool isHomeScreen,
) {
  return Card(
    elevation: 2.0,
    shape: const CircleBorder(),
    clipBehavior: Clip.antiAlias,
    child: CircleAvatar(
      maxRadius: isHomeScreen ? 30.0 : 60.0,
      backgroundColor: kPrimaryColor,
      child: image != null
          ? Image.file(image!, fit: BoxFit.fitWidth)
          : CachedNetworkImage(
              imageUrl: profileUrl ?? "",
              fit: BoxFit.fill,
              placeholder: (context, url) => const Padding(
                padding: EdgeInsets.all(18.0),
                child: CircularProgressIndicator(
                    strokeWidth: 1, color: kPrimaryColor),
              ),
              errorWidget: (context, url, error) =>
                  Image.asset("assets/avater.png"),
            ),
    ),
  );
}

Widget vehicleAvatar(isLarge, profileUrl, image) {
  return Card(
    elevation: 2.0,
    clipBehavior: Clip.antiAlias,
    child: Container(
      height: isLarge ? 128 : 50,
      width: isLarge ? 256 : 70,
      color: kPrimaryColor,
      child: image != null
          ? Image.file(image!, fit: BoxFit.fitWidth)
          : CachedNetworkImage(
              imageUrl: profileUrl ?? "",
              fit: BoxFit.fill,
              placeholder: (context, url) => const Padding(
                padding: EdgeInsets.all(18.0),
                child: CircularProgressIndicator(
                    strokeWidth: 1, color: kPrimaryColor),
              ),
              errorWidget: (context, url, error) =>
                  Image.asset("assets/addCar.png"),
            ),
    ),
  );
}
