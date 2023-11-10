import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';


class SharedPrefs {
  String value = "token";
  String isFirstLogin = "isFirstLogin";
  String allTabClicked = "allTabClicked";
  bool isFromImagePicker = false;
  SharedPreferences? prefs;
  bool isRatingActive = false;
  String ratingRequestId = "";
  int badge = 0;
  bool isCounterOffer = false;
  bool isRequestScheduled = false;
  String requestId = "";
  String scheduleRequestId = "";

  String counterOfferBadgeName = "CounterOffer";
  String isRequestScheduledName = "isRequestScheduled";
  String isRatingName = "isRatingName";
  String isRatingRequestId = "isRatingRequestId";
  String counterRequestIdBadgeName = "CounterRequestId";
  String scheduleRequestIdName = "scheduleRequestId";

  int pendingBadge = 0;
  int acceptedBadge = 0;
  int cancelBadge = 0;
  int completedBadge = 0;
  int historyBadge = 0;
  String estimateBadgeName = "Estimate";

  int? estimateBadgeNumber = 0;
  int? historyBadgeNumber = 0;
  int? pendingBadgeNumber = 0;
  int? acceptedBadgeNumber = 0;
  int? canceledBadgeNumber = 0;
  int? completedBadgeNumber = 0;

  String? token;
  bool? isFirstTimeLogin;
  bool? isAllTabClicked;

  initPrefs() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  saveToPrefs(k) async {
    await initPrefs();
    prefs!.setString(value, k);
  }

  saveIsFirstLogin() async {
    await initPrefs();
    prefs!.setBool(isFirstLogin, true);
  }

  setIsAllTabClicked() async {
    await initPrefs();
    prefs!.setBool(allTabClicked, true);
  }

  saveBadge(int num,badgeName) async {
    await initPrefs();
    prefs!.setInt(badgeName, num);
  }

  saveIsFromImagePicker(value) async {
    await initPrefs();
    prefs!.setBool("isFromImagePicker", value);
  }

  getIsFromImagePicker() async {
    await initPrefs();
    await prefs?.reload();
    isFromImagePicker = prefs?.getBool("isFromImagePicker") ?? false;
  }

  saveBool(bool num,badgeName) async {
    await initPrefs();
    prefs!.setBool(badgeName, num);
  }

  saveString(String num,badgeName) async {
    await initPrefs();
    prefs!.setString(badgeName, num);
  }

  getBadge(badgeName) async {
    await initPrefs();
    await prefs?.reload();
    estimateBadgeNumber = prefs?.getInt(badgeName);
  }

  // getHistoryBadge(badgeName) async {
  //   await initPrefs();
  //   estimateBadgeNumber = prefs?.getInt(badgeName);
  // }


  getPendingBadge(badgeName) async {
    await initPrefs();
    await prefs?.reload();
    pendingBadgeNumber = prefs?.getInt(badgeName);
  }

  getCounterOffer() async {
    await initPrefs();
    await prefs?.reload();
    isCounterOffer = prefs?.getBool(counterOfferBadgeName) ?? false;
    requestId = prefs?.getString(counterRequestIdBadgeName) ?? "";
  }

  getRatingOffer() async {
    await initPrefs();
    await prefs?.reload();
    isRatingActive = prefs?.getBool( isRatingName ) ?? false;
    ratingRequestId = prefs?.getString( isRatingRequestId ) ?? "";
  }

  getRequestOffer() async {
    await initPrefs();
    await prefs?.reload();
    isRequestScheduled = prefs?.getBool(isRequestScheduledName) ?? false;
    scheduleRequestId = prefs?.getString(scheduleRequestIdName) ?? "";
  }

  getAcceptedBadge(badgeName) async {
    await initPrefs();
    await prefs?.reload();
    acceptedBadgeNumber = prefs?.getInt(badgeName);
  }

  getCanceledBadge(badgeName) async {
    await initPrefs();
    await prefs?.reload();
    canceledBadgeNumber = prefs?.getInt(badgeName);
  }

  getCompletedBadge(badgeName) async {
    await initPrefs();
    await prefs?.reload();
    completedBadgeNumber = prefs?.getInt(badgeName);
  }

  removeEstimateBadge(badgeName) async {
    await initPrefs();
    prefs!.setInt(badgeName, 0);
  }

  removePendingBadge(badgeName) async {
    await initPrefs();
    prefs!.setInt(badgeName, 0);
  }

  removeCounterOffer() async {
    await initPrefs();
    prefs!.setBool(counterOfferBadgeName, false);
    prefs!.setString(counterRequestIdBadgeName, "");
  }

  removeRating() async {
    await initPrefs();
    prefs!.setBool( isRatingName , false);
    prefs!.setString( isRatingRequestId, "");
  }

  removeRequestOffer() async {
    await initPrefs();
    prefs!.setBool(isRequestScheduledName, false);
    prefs!.setString(scheduleRequestId, "");
  }

  removeAcceptedBadge(badgeName) async {
    await initPrefs();
    prefs!.setInt(badgeName, 0);
  }
  removeCanceledBadge(badgeName) async {
    await initPrefs();
    prefs!.setInt(badgeName, 0);
  }
  removeCompletedBadge(badgeName) async {
    await initPrefs();
    prefs!.setInt(badgeName, 0);
  }
  getIsFirstLogin() async {
    await initPrefs();
    isFirstTimeLogin = prefs?.getBool(isFirstLogin);
  }

  getIsAllTabClicked() async {
    await initPrefs();
    isAllTabClicked = prefs?.getBool(allTabClicked);
  }


  getToken() async {
    await initPrefs();
    token = prefs?.getString(value);
  }

  removeFromPrefs() async{
    await initPrefs();
    prefs!.remove(value);
  }


  badgeIncrementer() async {
    await prefs?.reload();
    badge = prefs?.getInt(estimateBadgeName) ?? 0 ;
    await saveBadge(badge + 1,estimateBadgeName);
  }

  counterOfferSetter(id) async{
    await prefs?.reload();
    isCounterOffer = true;
    requestId = id;
    await saveBool(isCounterOffer,counterOfferBadgeName);
    await saveString(requestId,counterRequestIdBadgeName);
  }

  ratingSetter(id) async{
    await prefs?.reload();
    isRatingActive = true;
    ratingRequestId = id;
    await saveBool( isRatingActive,isRatingName );
    await saveString( ratingRequestId ,isRatingRequestId);
  }

  requestOfferSetter(id) async{
    await prefs?.reload();
    isRequestScheduled = true;
    scheduleRequestId = id;
    await saveBool(isRequestScheduled,isRequestScheduledName);
    await saveString(scheduleRequestId,scheduleRequestIdName);
  }

  pendingBadgeIncrementer() async {
    await prefs?.reload();
    pendingBadge =  prefs?.getInt(pendingConst) ?? 0;
    await saveBadge(pendingBadge + 1,pendingConst);
  }

  acceptedBadgeIncrementer() async {
    await prefs?.reload();
    acceptedBadge = prefs?.getInt(acceptedConst) ?? 0 ;
    await saveBadge(acceptedBadge + 1, acceptedConst);
  }

  canceledBadgeIncrementer() async {
    await prefs?.reload();
    cancelBadge = prefs?.getInt(canceledConst) ?? 0;
    await saveBadge(cancelBadge + 1,canceledConst);
  }

  completedBadgeIncrementer() async {
    completedBadge = prefs?.getInt(completedConst) ?? 0;
    await saveBadge(completedBadge + 1, completedConst);
  }

}