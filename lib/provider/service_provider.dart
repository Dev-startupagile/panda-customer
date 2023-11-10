import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:http/http.dart' as http;
import '../models/service_model.dart';
import '../util/api.dart';
import '../function/shared_prefs.dart';

class ServiceProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoaded = false;
  final sharedPrefs = SharedPrefs();
  List<Datum> services = [];

  Future<http.Response?> getAllServices(context, isRefreshed) async {
    http.Response? response;
    await sharedPrefs.getToken();

    if (services.isEmpty || isRefreshed) {
      isLoading = true;
      notifyListeners();
      try {
        notifyListeners();
        response = await http.get(
          Uri.parse('$apiUrl/service/all'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
          },
        );

        if (response.statusCode == 200) {
          isLoading = false;
          isLoaded = true;
          final result = serviceModelFromJson(response.body);
          services = result.data;
          notifyListeners();
        } else {
          isLoading = false;
          displayErrorSnackBar(context, "Something went wrong");
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
