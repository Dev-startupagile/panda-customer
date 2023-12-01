import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda/core/exceptions/app_http_exceptions.dart';
import 'package:panda/function/global_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:panda/models/tokenized_card.dart';
import 'package:stripe_payment/stripe_payment.dart';
import '../commonComponents/loading_dialog.dart';
import '../models/add_card_model.dart';
import '../models/add_vehicle_form_model.dart';
import '../models/customer_profile_model.dart';
import '../util/api.dart';
import '../function/shared_prefs.dart';

class ProfileProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoaded = false;
  final sharedPrefs = SharedPrefs();
  Data? customerprofile;
  final dialog = DialogHandler();
  String? userId;

  Future<http.Response?> customerProfile(context) async {
    http.Response? response;
    isLoading = true;
    notifyListeners();
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      response = await http.get(
        Uri.parse('$apiUrl/auth/profile'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
        },
      );
      if (response.statusCode == 200) {
        isLoading = false;
        isLoaded = true;
        final result = customerProfileModelFromJson(response.body);
        customerprofile = result.data;
        userId = result.data.personalInformation.id;
        notifyListeners();
      } else if (response.statusCode == 403) {
        isLoading = false;
        Navigator.pushNamed(context, "/login");
        displayErrorSnackBar(context, "account not verified!");
        notifyListeners();
      } else {
        isLoading = false;
        Navigator.pushNamed(context, "/login");
        displayErrorSnackBar(
            context, "Something went wrong, customer provider");
        notifyListeners();
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

    notifyListeners();
    return response;
  }

  Future<http.Response?> editPassword(
      context, email, currentPassword, newPassword) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();

    try {
      notifyListeners();
      response = await http.patch(Uri.parse('$apiUrl/auth/changePassword'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
          },
          body: jsonEncode({
            "email": email,
            "currentPassword": currentPassword,
            "newPassword": newPassword
          }));

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);
        Navigator.pop(context);
        notifyListeners();
      } else if (response.statusCode == 400) {
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Verification fail");
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

  Future<http.Response?> editProfileInformation(context, email, data) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();

    try {
      notifyListeners();
      response = await http.patch(Uri.parse('$apiUrl/users/$email'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
          },
          body: jsonEncode(data));

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);
        final result = customerProfileModelFromJson(response.body);
        customerprofile = result.data;
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

  Future<http.Response?> deleteAccount(context) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();

    try {
      notifyListeners();
      response = await http.delete(
        Uri.parse('$apiUrl/auth/removeUser/$userId'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
        },
      );

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);
        Navigator.of(context).pushNamed('/login');
        sharedPrefs.removeFromPrefs();
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

  Future<http.Response?> addCard(context, AddCardModel data) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      List<int> expiryDate =
          data.expiryDate.split("/").map((e) => int.parse(e)).toList();
      Token token = await StripePayment.createTokenWithCard(CreditCard(
          number: data.cardNumber,
          cvc: data.cvc,
          expMonth: expiryDate[0],
          expYear: expiryDate[1]));
      if (token.tokenId == null) {
        throw AppFuncException("Getting Tokenized Card failed");
      }
      var tokenizedCard = TokenizedCard(
        id: '',
        email: '',
        tokenId: token.tokenId!,
        length: data.cardNumber.length,
        lastFour: data.getLastFour(),
        customerName: data.type,
        isActive: true,
      );

      response = await http.post(Uri.parse('$apiUrl/account/addCard'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
          },
          body: tokenizedCard.toJson());

      if (response.statusCode == 201) {
        dialog.closeLoadingDialog(context);
        final result = customerProfileModelFromJson(response.body);
        customerprofile = result.data;

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

  Future<http.Response?> removeCard(context, id) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      response = await http.delete(
        Uri.parse('$apiUrl/account/card/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
        },
      );

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);

        customerprofile?.payments.items.removeWhere((TokenizedCard element) {
          return element.id == id;
        });

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
      notifyListeners();
    }

    notifyListeners();
    return response;
  }

  Future<http.Response?> addVehicle(context, AddVehicleModel data) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      response = await http.post(Uri.parse('$apiUrl/vehicle/add'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
          },
          body: jsonEncode(data.toJson()));

      if (response.statusCode == 201) {
        dialog.closeLoadingDialog(context);
        final result = customerProfileModelFromJson(response.body);
        customerprofile = result.data;

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

  Future<http.Response?> removeVehicle(context, id) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      response = await http.delete(
        Uri.parse('$apiUrl/vehicle/$id'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer ${sharedPrefs.token}"
        },
      );

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);
        final result = customerProfileModelFromJson(response.body);
        customerprofile = result.data;
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
