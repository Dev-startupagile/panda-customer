import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:http/http.dart' as http;
import '../models/technician_model.dart';
import '../util/api.dart';
import '../function/shared_prefs.dart';


class UserDetailByEmailProvider extends ChangeNotifier {

  bool isLoading = false;
  bool isLoaded = false;
  final sharedPrefs = SharedPrefs();
  Data? userdetail;

  Future<http.Response?> userDetail(context,email) async {
    http.Response? response;
    isLoading = true;
    notifyListeners();
    sharedPrefs.getToken();
    try {
      notifyListeners();
      response =
      await http.get(
          Uri.parse('$apiUrl/users/$email'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:"Bearer ${sharedPrefs.token}"
          },
      );

      if (response.statusCode == 200) {
        isLoading = false;
        isLoaded = true;
        final result = technicianProfileModelFromJson(response.body);
        userdetail = result.data;
        notifyListeners();

      } else{
        isLoading = false;
        displayErrorSnackBar(context, "Something went wrong");
        notifyListeners();
      }

    }  on SocketException catch (e) {
      isLoading = false;
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch(e){
      isLoading = false;
      displayErrorSnackBar(context, e.toString());
      notifyListeners();
    }

    notifyListeners();
    return response;
  }



}