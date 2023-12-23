import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:panda/models/contact_us_model.dart';
import 'package:http/http.dart' as http;
import '../commonComponents/loading_dialog.dart';
import '../util/api.dart';
import '../function/shared_prefs.dart';

class ContactUsProvider extends ChangeNotifier {
  final sharedPrefs = SharedPrefs();
  final dialog = DialogHandler();

  Future<http.Response?> contactUs(context, AddContactUsModel data) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();

    try {
      notifyListeners();
      response = await http.post(Uri.parse('$apiUrl/contactUs'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
          },
          body: jsonEncode(data.toJson()));

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);

        Navigator.pop(context);
        notifyListeners();
      } else {
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Something went wrong");
        notifyListeners();
      }
    } on SocketException catch (e) {
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch (e) {
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, e.toString());
      notifyListeners();
    }

    notifyListeners();
    return response;
  }
}
