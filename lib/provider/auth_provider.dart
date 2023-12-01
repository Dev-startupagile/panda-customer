import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:panda/commonComponents/loading_dialog.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:panda/models/signup_form_model.dart';

import '../function/shared_prefs.dart';
import '../models/signin_model.dart';
import '../models/verify_response_model.dart';
import '../screens/auth/verification.dart';
import '../util/api.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isOtpSent = false;
  bool isVerificationLoding = false;
  final sharedPrefs = SharedPrefs();
  final dialog = DialogHandler();

  Future signOut(context) async {
    sharedPrefs.removeFromPrefs();
    Navigator.pushNamed(context, "/login");
  }

  Future<http.Response?> signIn(context, email, password, fcmToken) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();

    try {
      notifyListeners();
      response = await http.post(Uri.parse('$apiUrl/auth/login'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: jsonEncode({
            "email": email,
            "password": password,
            "userRole": "customer",
            "fcm_token": fcmToken
          }));

      if (response.statusCode == 200) {
        final token = signInModelFromJson(response.body);
        dialog.closeLoadingDialog(context);
        sharedPrefs.saveIsFirstLogin();
        Navigator.of(context).pushNamed('/home');
        sharedPrefs.saveToPrefs(token.token);
        notifyListeners();
      } else if (response.statusCode == 400) {
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Invalid Username or Password");
        notifyListeners();
      } else if (response.statusCode == 404) {
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "User Not Found");
        notifyListeners();
      } else {
        print(response.body);
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Something went wrong, Login");
        notifyListeners();
      }
    } on SocketException catch (e) {
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch (e) {
      dialog.closeLoadingDialog(context);
      print(e.toString());
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    }

    notifyListeners();
    return response;
  }

  Future<http.Response?> signUp(context, SignUpModel data) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    try {
      notifyListeners();
      response = await http.post(Uri.parse('$apiUrl/auth/signup'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: jsonEncode(data.toJson()));

      print(response.body);
      if (response.statusCode == 201) {
        dialog.closeLoadingDialog(context);
        sharedPrefs.saveIsFirstLogin();

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Verification(
                    email: data.email,
                    isFromReset: false,
                    phoneNumber: data.phoneNumber,
                  )),
        );
      } else if (response.statusCode == 400) {
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "User already Exist");
        notifyListeners();
      } else if (response.statusCode == 404) {
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "User Not Found");
        notifyListeners();
      } else {
        print(response.body);
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, response.body);
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

  Future<http.Response?> verifyUser(context, email, code) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();

    try {
      notifyListeners();
      response = await http.post(Uri.parse('$apiUrl/auth/verify'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: jsonEncode({"email": email, "code": code}));

      print(response.body);
      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);
        final token = verifyResponseModelFromJson(response.body);
        sharedPrefs.saveToPrefs(token.token);

        Navigator.of(context).pushNamed('/home');
        notifyListeners();
      } else if (response.statusCode == 400) {
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Verification Code  Is Invalid!");
        notifyListeners();
      } else {
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(
            context, "${response.statusCode} ${response.body}");
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

  Future<http.Response?> resetPassword(context, email, password, otp) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();

    try {
      notifyListeners();
      response = await http.patch(Uri.parse('$apiUrl/auth/resetPassword'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: jsonEncode({
            "email": email,
            "newPassword": password,
            "otp": int.parse(otp)
          }));

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);
        displaySuccessSnackBar(context, "you reset password successfully");
        Navigator.of(context).pushNamed('/login');
        notifyListeners();
      } else if (response.statusCode == 400) {
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Verification Fail!");
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

  Future<http.Response?> sendOtp(context, email, isFromReset) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();

    try {
      notifyListeners();
      response = await http.post(Uri.parse('$apiUrl/auth/sendOTP'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: jsonEncode({
            "email": email,
          }));

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);
        if (isFromReset) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Verification(email: email, isFromReset: isFromReset)),
          );
        }

        notifyListeners();
      } else if (response.statusCode == 404) {
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "User Not Found!");
        notifyListeners();
      } else if (response.statusCode == 400) {
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(
            context, "You need to wait 2 Min to send another Code!");
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
