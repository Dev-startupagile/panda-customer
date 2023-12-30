import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:panda/models/review_model.dart';
import '../function/global_snackbar.dart';
import '../function/shared_prefs.dart';
import '../util/api.dart';

class RatingProvider extends ChangeNotifier {
  bool isRatingActive = false;
  bool isLoading = false;
  String ratingRequestId = "";
  final sharedPrefs = SharedPrefs();

  ratingSetter(id) {
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

  updateRating() async {
    isRatingActive = false;
    await sharedPrefs.removeRating();
    notifyListeners();
  }

  Future<List<ReviewModel>> getMyReviews(context) async {
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      http.Response? response = await http.get(
        Uri.parse('$apiUrl/reviews/get_my_reviews'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map<ReviewModel>((e) => ReviewModel.fromMap(e)).toList();
      } else if (response.statusCode == 403) {
        isLoading = false;
        Navigator.pushNamed(context, "/login");
        displayErrorSnackBar(context, "account not verified!");
        notifyListeners();
        return [];
      } else {
        isLoading = false;
        Navigator.pushNamed(context, "/login");
        displayErrorSnackBar(
            context, "Something went wrong, customer provider");
        notifyListeners();
        return [];
      }
    } on SocketException catch (e) {
      isLoading = false;
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch (e) {
      isLoading = false;
      displayErrorSnackBar(context, e.toString());
      notifyListeners();
    }
    return [];
  }

  Future<List<ReviewModel>> getFeedBack(context) async {
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      http.Response? response = await http.get(
        Uri.parse('$apiUrl/reviews/get_my_feedbacks'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map<ReviewModel>((e) => ReviewModel.fromMap(e)).toList();
      } else if (response.statusCode == 403) {
        isLoading = false;
        Navigator.pushNamed(context, "/login");
        displayErrorSnackBar(context, "account not verified!");
        notifyListeners();
        return [];
      } else {
        isLoading = false;
        Navigator.pushNamed(context, "/login");
        displayErrorSnackBar(
            context, "Something went wrong, customer provider");
        notifyListeners();
        return [];
      }
    } on SocketException catch (e) {
      isLoading = false;
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch (e) {
      isLoading = false;
      displayErrorSnackBar(context, e.toString());
      notifyListeners();
    }
    return [];
  }

  Future<List<ReviewModel>> getReview(context, id) async {
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      http.Response? response = await http.get(
        Uri.parse(
            '$apiUrl/reviews/get_review?email=${Uri.encodeComponent(id)}'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> list = List.from(data["data"]);
        return list.map<ReviewModel>((e) => ReviewModel.fromMap(e)).toList();
      } else if (response.statusCode == 403) {
        isLoading = false;
        // Navigator.pushNamed(context, "/login");
        displayErrorSnackBar(context, "account not verified!");
        return [];
      } else {
        isLoading = false;
        // Navigator.pushNamed(context, "/login");
        displayErrorSnackBar(
            context, "Something went wrong, customer provider");
        return [];
      }
    } on SocketException catch (e) {
      isLoading = false;
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch (e) {
      isLoading = false;
      displayErrorSnackBar(context, e.toString());
      notifyListeners();
    }
    return [];
  }

  Future<bool> deleteReview(context, id) async {
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      http.Response? response = await http.delete(
        Uri.parse('$apiUrl/reviews/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 403) {
        isLoading = false;
        Navigator.pushNamed(context, "/login");
        displayErrorSnackBar(context, "account not verified!");
        notifyListeners();
        return false;
      } else {
        isLoading = false;
        Navigator.pushNamed(context, "/login");
        displayErrorSnackBar(
            context, "Something went wrong, customer provider");
        notifyListeners();
        return false;
      }
    } on SocketException catch (e) {
      isLoading = false;
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch (e) {
      isLoading = false;
      displayErrorSnackBar(context, e.toString());
      notifyListeners();
    }
    return false;
  }

  Future<ReviewModel> sendRating(context, String to, double rating,
      String? requestId, String feedback) async {
    http.Response? response;
    await sharedPrefs.getToken();

    isLoading = true;
    notifyListeners();
    var review;
    try {
      response = await http.post(Uri.parse('$apiUrl/reviews/add_review'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
          },
          body: jsonEncode({
            "rating": rating,
            "to_email": to,
            "requestId": requestId,
            "review": feedback
          }));

      if (response.statusCode == 201) {
        isLoading = false;
        Map<String, dynamic> data = json.decode(response.body);
        review = ReviewModel.fromMap(data["data"]);
      } else {
        throw Exception("Something went wrong code: ${response.statusCode}");
      }
    } on SocketException catch (e) {
      isLoading = false;
      displayErrorSnackBar(context, "please check your internet and try again");
    } catch (e) {
      isLoading = false;
      displayErrorSnackBar(context, "Something went wrong");
    }

    return review;
  }
}
