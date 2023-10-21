import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:http/http.dart' as http;
import '../commonComponents/loading_dialog.dart';
import '../models/estimate_model.dart';
import '../util/api.dart';
import '../function/shared_prefs.dart';

class EstimateProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoaded = false;
  final sharedPrefs = SharedPrefs();
  final dialog = DialogHandler();

  List<Datum> estimates = [];
  List<Datum> estimateDetail = [];

  Future<http.Response?> getEstimate(context) async {
    http.Response? response;
    await sharedPrefs.getToken();

    if (true) {
      isLoading = true;
      notifyListeners();
      try {
        notifyListeners();
        response = await http.get(
          Uri.parse('$apiUrl/offerEstimation/customer'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
          },
        );

        if (response.statusCode == 200) {
          isLoading = false;
          isLoaded = true;
          final result = estimateModelFromJson(response.body);
          estimates = result.data;
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
    }

    notifyListeners();
    return response;
  }

  Future<http.Response?> getEstimateById(context, requestId) async {
    http.Response? response;
    await sharedPrefs.getToken();

    print("Your request Id is $requestId");

    if (true) {
      isLoading = true;
      notifyListeners();
      try {
        notifyListeners();
        response = await http.get(
          Uri.parse('$apiUrl/offerEstimation/byRquest/$requestId'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
          },
        );

        print("Calama Clama ${response.body}");

        if (response.statusCode == 200) {
          isLoading = false;
          isLoaded = true;
          final result = estimateModelFromJson(response.body);
          estimateDetail = result.data;
          notifyListeners();
        } else {
          isLoading = true;
          displayErrorSnackBar(context, "Something went wrong");
          notifyListeners();
        }
      } on SocketException catch (e) {
        isLoading = true;
        displayErrorSnackBar(
            context, "please check your internet and try again");
        notifyListeners();
      } catch (e) {
        isLoading = true;
        print(e.toString());
        displayErrorSnackBar(context, e.toString());
        notifyListeners();
      }
    }

    notifyListeners();
    return response;
  }

  Future<http.Response?> approveEstimate(context, id) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      response = await http.patch(
        Uri.parse('$apiUrl/offerEstimation/approve/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);
        displaySuccessSnackBar(context, "You  Accepted Estimate Successfully");
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

  Future<http.Response?> declineEstimate(context, id) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      response = await http.patch(
        Uri.parse('$apiUrl/offerEstimation/reject/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
        },
      );

      if (response.statusCode == 200) {
        // final result = estimateResponseModelFromJson(response.body);
        dialog.closeLoadingDialog(context);
        displaySuccessSnackBar(context, "You  Declined Estimate Successfully");
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
