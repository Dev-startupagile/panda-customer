import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../function/global_snackbar.dart';
import '../function/shared_prefs.dart';
import '../util/api.dart';


class RatingProvider extends ChangeNotifier {


  bool isRatingActive = false;
  bool isLoading = false;
  String ratingRequestId = "";
  final sharedPrefs = SharedPrefs();

  ratingSetter(id){
    isRatingActive = true;
    ratingRequestId = id;

    notifyListeners();
  }

  getRating() async {
    await sharedPrefs.getRatingOffer();
    isRatingActive = sharedPrefs.isRatingActive;
    ratingRequestId = sharedPrefs.ratingRequestId;
    notifyListeners();
  }

  updateRating() async{
    isRatingActive = false;
    await sharedPrefs.removeRating();
    notifyListeners();
  }

  Future<http.Response?> sendRating(context,String to, double rating, String requestId, String feedback) async {
    http.Response? response;
    await sharedPrefs.getToken();

    if(true){
      isLoading = true;
      notifyListeners();
      try {
        response =
        await http.post(
            Uri.parse('$apiUrl/rating/send'),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader:"Bearer ${sharedPrefs.token}"
            },
            body:jsonEncode(
                {
                  "rating": rating,
                  "to": to,
                  "requestId": requestId,
                  "feedback": feedback
                }
            )
        );

        if (response.statusCode == 201) {
          isLoading = false;

          notifyListeners();

        }else{
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
        // displayErrorSnackBar(context, e.toString());
        notifyListeners();
      }

      notifyListeners();
      return response;
    }
  }

}