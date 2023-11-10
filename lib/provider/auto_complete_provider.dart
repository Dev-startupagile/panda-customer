import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:panda/function/global_snackbar.dart';
import '../models/auto_complate_model.dart';
import '../util/api.dart';

class AutoCompleteProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Prediction?>? placeList = [];

  Future<http.Response?> getPlace(context, text) async {
    http.Response? response;

    if (true) {
      isLoading = true;
      notifyListeners();
      try {
        notifyListeners();
        response = await http.get(
          Uri.parse(
              'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=$googleApi'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        );

        print(response.body);
        if (response.statusCode == 200) {
          isLoading = false;
          final result = placeModelFromJson(response.body);
          placeList = result?.predictions;
          notifyListeners();
        } else {
          isLoading = false;
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
