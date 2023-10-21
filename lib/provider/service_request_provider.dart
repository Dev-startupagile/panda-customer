import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:panda/function/global_snackbar.dart';
import 'package:panda/models/add_service_request_model.dart';
import 'package:panda/screens/home/history/status/technician_nearby.dart';

import '../commonComponents/loading_dialog.dart';
import '../function/shared_prefs.dart';
import '../models/customer_profile_model.dart';
import '../models/request_detail_model.dart' as reqDetail;
import '../models/request_status_model.dart';
import '../models/send_request_response_model.dart' as sendrequest;
import '../util/api.dart';



class ServiceRequestProvider extends ChangeNotifier {

  bool isLoading = false;
  bool isLoaded = false;
  bool isPendingLoaded = false;
  bool isAcceptedLoaded = false;
  bool isCanceledLoaded = false;
  bool isCompletedLoaded = false;
  bool isCompletedAllLoaded = false;

  final sharedPrefs = SharedPrefs();
  Data? customerprofile;
  String requestId = "";
  List<Datum> requests = [];
  reqDetail.Data? requestDetail;
  // List<Datum> acceptedRequests = [];
  // List<Datum> canceledRequests = [];
  // List<Datum> completedRequests = [];
  // List<Datum> completedAllRequests = [];


  final dialog = DialogHandler();
  String? userId;

  Future<http.Response?> sendServiceRequest(context,AddServiceRequestModel data, attachments,vehicleId) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();

    try {
      notifyListeners();
      response =
      await http.post(
          Uri.parse('$apiUrl/request/send'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:"Bearer ${sharedPrefs.token}"
          },
          body: jsonEncode(
              {
                "serviceId": data.serviceId,
                "vehicleId": [vehicleId],
                "paymentId":data.paymentId,
                "serviceLocation": {
                  "longitude": data.longitude,
                  "latitude": data.latitude,
                  "name": data.name
                },
                "schedule": {
                  "date": data.date,
                  "time": data.time
                },
                "description": {
                  "note": data.note,
                  "attachments": attachments,
                  "title": data.title
                }
              }
          )
      );

      print(response.body);
      if (response.statusCode == 201) {
        dialog.closeLoadingDialog(context);
        final result = sendrequest.sendRequestresponseModelFromJson(response.body);
        requestId = result.data.id;
        print("calma calmaaa ${result.data.id}");
        notifyListeners();
        displaySuccessSnackBar(context, "you requested service succesfuly");
      } else if(response.statusCode == 400){
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Verification fail");
        notifyListeners();
      }
      else{
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Something went wrong");
        notifyListeners();
      }

    }  on SocketException catch (e) {
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch(e){
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, e.toString());
      notifyListeners();
    }

    notifyListeners();
    return response;
  }


  Future<http.Response?> reRequestService(context,requestId,date,time) async {
    http.Response? response;
    dialog.openLoadingDialog(context);

    notifyListeners();
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      response =
      await http.patch(
          Uri.parse('$apiUrl/request/$requestId'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:"Bearer ${sharedPrefs.token}"
          },
          body: jsonEncode(
              {
                "requestStatus": "PENDING",
                "isScheduled": true,
                "schedule": {
                  "date": date,
                  "time": time
                }
              }
          )
      );

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);
        notifyListeners();
        displaySuccessSnackBar(context, "you re-requested service successfuly");
      } else{
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Something went wrong");
        notifyListeners();
      }

    }  on SocketException catch (e) {
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch(e){
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, e.toString());
      notifyListeners();
    }

    notifyListeners();
    return response;
  }


  Future<http.Response?> getRequestById(context,requestId) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    isLoading  = true;
    notifyListeners();
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      response =
      await http.get(
          Uri.parse('$apiUrl/request/$requestId'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:"Bearer ${sharedPrefs.token}"
          },
      );

      if (response.statusCode == 200) {
        final result = reqDetail.requestDetailModelFromJson(response.body);
        requestDetail = result.data;
        isLoading  = false;

        dialog.closeLoadingDialog(context);
        notifyListeners();
      } else{
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Something went wrong");
        isLoading  = false;
        notifyListeners();
      }

    }  on SocketException catch (e) {
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, "please check your internet and try again");
      isLoading  = false;

      notifyListeners();
    } catch(e){
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, e.toString());
      isLoading  = false;

      notifyListeners();
    }

    isLoading  = false;
    notifyListeners();
    return response;
  }


  Future<http.Response?> reRequestCanceledService(context,Datum requestDetail,requestId) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      response =
      await http.patch(
          Uri.parse('$apiUrl/request/$requestId'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:"Bearer ${sharedPrefs.token}"
          },
          body: jsonEncode(
              {
                "requestStatus": "PENDING",
              }
          )
      );

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);
        requests.removeWhere((Datum element){
          return element.id == requestId;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NearByTechnician(latitude:requestDetail.serviceLocation?.latitude ?? 0.0 , longitude: requestDetail.serviceLocation?.longitude ?? 0.0)
        ));

        notifyListeners();
        displaySuccessSnackBar(context, "you re-requested service successfuly");
      } else{
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Something went wrong");
        notifyListeners();
      }

    }  on SocketException catch (e) {
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch(e){
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, e.toString());
      notifyListeners();
    }

    notifyListeners();
    return response;
  }

  Future<http.Response?> getServiceRequestByStatus(context,status) async {
    http.Response? response;
    await sharedPrefs.getToken();
     isLoaded = false;
     isLoading = true;
     notifyListeners();
     try {
       notifyListeners();
       response =
       await http.get(
         Uri.parse('$apiUrl/request/byStatus/$status'),
         headers: {
           HttpHeaders.contentTypeHeader: "application/json",
           HttpHeaders.authorizationHeader:"Bearer ${sharedPrefs.token}"
         },
       );

       print(status);
       if (response.statusCode == 200) {
         final result = requestStatusModelFromJson(response.body);

         requests = result.data;
         isLoaded = true;


         isLoading = false;
         notifyListeners();
       } else{
         displayErrorSnackBar(context, "Something went wrong");
         isLoading = false;
         notifyListeners();
       }

     }  on SocketException catch (e) {
       isLoading = false;
       displayErrorSnackBar(context, "please check your internet and try again");
       notifyListeners();
     } catch(e){
       isLoading = false;

       print(e.toString());
       displayErrorSnackBar(context, e.toString());
       notifyListeners();
     }
    notifyListeners();
    return response;
  }


  Future<http.Response?> updateServiceRequestByStatus(context,technicianId) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();

    try {
      notifyListeners();
      response =
      await http.patch(
        Uri.parse('$apiUrl/request/$requestId'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader:"Bearer ${sharedPrefs.token}"
        },
        body: jsonEncode({
          "technicianId":technicianId
        })
      );

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);
        notifyListeners();
      } else{
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Something went wrong");
        notifyListeners();
      }

    }  on SocketException catch (e) {
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch(e){
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, e.toString());
      notifyListeners();
    }

    notifyListeners();
    return response;
  }

  Future<http.Response?> cancelServiceRequest(context, id) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      response =
      await http.patch(
          Uri.parse('$apiUrl/request/$id'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:"Bearer ${sharedPrefs.token}"
          },
        body: jsonEncode(
            {
              "requestStatus": "CANCELED",
            }
        )
      );

      print("hollaa ${response.body}");

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);

        requests.removeWhere((Datum element){
          return element.id == id;
        });

        displaySuccessSnackBar(context, "you canceled service request successfully");

      } else{
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Something went wrong");
        notifyListeners();
      }

    }  on SocketException catch (e) {
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch(e){
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, e.toString());
      notifyListeners();
    }

    notifyListeners();
    return response;
  }

  Future<http.Response?> acceptServiceRequest(context, id) async {
    http.Response? response;
    dialog.openLoadingDialog(context);
    notifyListeners();
    await sharedPrefs.getToken();
    try {
      notifyListeners();
      response =
      await http.patch(
          Uri.parse('$apiUrl/request/$id'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader:"Bearer ${sharedPrefs.token}"
          },
          body: jsonEncode(
              {
                "requestStatus": "ACCEPTED",
              }
          )
      );

      if (response.statusCode == 200) {
        dialog.closeLoadingDialog(context);


        displaySuccessSnackBar(context, "you canceled service request successfully");

      } else{
        dialog.closeLoadingDialog(context);
        displayErrorSnackBar(context, "Something went wrong");
        notifyListeners();
      }

    }  on SocketException catch (e) {
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, "please check your internet and try again");
      notifyListeners();
    } catch(e){
      dialog.closeLoadingDialog(context);
      displayErrorSnackBar(context, e.toString());
      notifyListeners();
    }

    notifyListeners();
    return response;
  }
}