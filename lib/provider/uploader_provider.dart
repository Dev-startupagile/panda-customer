import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panda/function/random_number_generator.dart';
import 'package:path/path.dart' as path;
import 'package:panda/function/global_snackbar.dart';
import 'package:http/http.dart' as http;
import '../services/aws_service.dart';
import '../util/api.dart';
import '../function/shared_prefs.dart';
import 'package:http_parser/http_parser.dart' as parser;


class UploaderProvider extends ChangeNotifier {

  bool isLoading = false;
  bool isMultiLoading = false;
  final sharedPrefs = SharedPrefs();
  String? uplodedFile;
  List<String> uploadedFileList = [];

  Future<Response?> imageUploader(context,File file) async {
    Response? response;
    isLoading = true;
    uplodedFile = null;
    uploadedFileList = [];
    notifyListeners();
    String filePath = file.path.split('/').last;
    Uint8List bytesImage = file. readAsBytesSync();
    String url =  random().toString() + filePath;

    try {
      var isUploaded = await AWSClient().uploadData(
          'panda/image', url, bytesImage);

          if(isUploaded){
            isLoading = false;
            uplodedFile = '$imageUrl/$url';
            notifyListeners();
          }else{
            isLoading = false;
            notifyListeners();
            displayErrorSnackBar(context, "unable to upload image");
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

  removeMultiImage(i){
    uploadedFileList.removeAt(i);
    notifyListeners();
  }


  Future<Response?> maltiImageUploader(context,List<XFile> file) async {
    Response? response;
    isLoading = true;
    isMultiLoading = true;
    uploadedFileList = [];
    notifyListeners();

    print("Loading");

    for(int i=0;i<file.length;i++){
      String filePath = file[i].path.split('/').last;
      Uint8List bytesImage = File(file[i].path).readAsBytesSync();
      String url =  random().toString() + filePath;

      try {
        var isUploaded = await AWSClient(). uploadData(
            'panda/image', url, bytesImage);

        if(isUploaded){
          isLoading = false;
          uploadedFileList.add('$imageUrl/$url');
          print("hello magnaw ${i}");

          if(i == (file.length-1)){
            isMultiLoading = false;
          }

          notifyListeners();
        }else{
          isLoading = false;
          notifyListeners();
          displayErrorSnackBar(context, "unable to upload image");
        } }  on SocketException catch (e) {
        isLoading = false;
        displayErrorSnackBar(context, "please check your internet and try again");
        notifyListeners();
      } catch(e){
        isLoading = false;
        displayErrorSnackBar(context, e.toString());
        notifyListeners();
      }
    }


    notifyListeners();
    return response;
  }

  initialValue(){
    uploadedFileList = [];
    isLoading = false;
    isMultiLoading = false;
    notifyListeners();
  }

}