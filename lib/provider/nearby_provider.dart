import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:panda/function/global_snackbar.dart';

import '../function/shared_prefs.dart';
import '../models/nearby_model.dart';
import '../util/api.dart';

class NearByProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoaded = false;
  final sharedPrefs = SharedPrefs();
  List<Datum> nearby = [];

  Future<http.Response?> nearBy(
      context, lat, lng, backToHome, isRefreshed) async {
    http.Response? response;
    await sharedPrefs.getToken();

    if (true) {
      isLoading = true;
      notifyListeners();
      try {
        notifyListeners();
        //TODO: stay http rest call for now
        response = await http.post(Uri.parse('$apiUrl/users/technician/nearby'),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
            },
            body: jsonEncode({"latitude": lat, "longitude": lng}));

        if (response.statusCode == 200) {
          isLoading = false;
          isLoaded = true;
          final result = nearByModelFromJson(response.body);
          nearby = result.data;

          if (nearby.isEmpty) {
            backToHome();
            // Navigator.pushNamed(context, "/from_nearby");
          }
          notifyListeners();
        } else {
          isLoading = false;
          displayErrorSnackBar(context, "Something went wrong nearby");
          notifyListeners();
        }
      } on SocketException catch (e) {
        isLoading = false;
        displayErrorSnackBar(
            context, "please check your internet and try again");
        notifyListeners();
      } catch (e) {
        isLoading = false;
        displayErrorSnackBar(context, e.toString());
        notifyListeners();
      }

      notifyListeners();
      return response;
    }
  }
}
