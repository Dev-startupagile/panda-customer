import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panda/provider/estimate_provider.dart';
import 'package:panda/util/constants.dart';

import '../function/shared_prefs.dart';

class NotificationProvider extends ChangeNotifier {
  String estimateBadgeName = "Estimate";
  int badge = 0;
  bool isCounterOffer = false;
  bool isRequestScheduled = false;
  String scheduleRequestId = "";

  int pendingBadge = 0;
  int acceptedBadge = 0;
  int cancelBadge = 0;
  int completedBadge = 0;
  int historyBadge = 0;
  String requestId = "";
  final sharedPrefs = SharedPrefs();

  counterOfferSetter(id) {
    isCounterOffer = true;
    requestId = id;
    notifyListeners();
  }

  requestOfferSetter(id) {
    isRequestScheduled = true;
    scheduleRequestId = id;
    notifyListeners();
  }

  updateCounterOffer() async {
    isCounterOffer = false;
    await sharedPrefs.removeCounterOffer();
    notifyListeners();
  }

  updateRequestOffer() async {
    isRequestScheduled = false;
    await sharedPrefs.removeRequestOffer();
    notifyListeners();
  }

  badgeIncrementer() async {
    badge++;
    notifyListeners();
    await sharedPrefs.saveBadge(badge, estimateBadgeName);
  }

  pendingBadgeIncrementer() async {
    pendingBadge++;
    historyBadge = acceptedBadge + pendingBadge + cancelBadge + completedBadge;
    notifyListeners();
    await sharedPrefs.saveBadge(pendingBadge, pendingConst);
  }

  acceptedBadgeIncrementer() async {
    acceptedBadge++;
    historyBadge = acceptedBadge + pendingBadge + cancelBadge + completedBadge;
    notifyListeners();
    await sharedPrefs.saveBadge(acceptedBadge, acceptedConst);
  }

  canceledBadgeIncrementer() async {
    cancelBadge++;
    historyBadge = acceptedBadge + pendingBadge + cancelBadge + completedBadge;
    notifyListeners();
    await sharedPrefs.saveBadge(cancelBadge, canceledConst);
  }

  completedBadgeIncrementer() async {
    completedBadge++;
    historyBadge = acceptedBadge + pendingBadge + cancelBadge + completedBadge;
    notifyListeners();
    await sharedPrefs.saveBadge(completedBadge, completedConst);
  }

  Future<void> getBadge() async {
    badge = await EstimateProvider().countEstimate();
    notifyListeners();
  }

  getPendingBadge() async {
    await sharedPrefs.getPendingBadge(pendingConst);
    pendingBadge = sharedPrefs.pendingBadgeNumber ?? 0;
    historyBadge = acceptedBadge + pendingBadge + cancelBadge + completedBadge;
    notifyListeners();
  }

  getCounterOffer() async {
    await sharedPrefs.getCounterOffer();
    isCounterOffer = sharedPrefs.isCounterOffer;
    requestId = sharedPrefs.requestId;
    notifyListeners();
  }

  getRequestOffer() async {
    await sharedPrefs.getRequestOffer();
    isRequestScheduled = sharedPrefs.isRequestScheduled;
    scheduleRequestId = sharedPrefs.scheduleRequestId;
    notifyListeners();
  }

  resetCounterOffer() async {
    isCounterOffer = false;
    notifyListeners();
  }

  getAcceptedBadge() async {
    await sharedPrefs.getAcceptedBadge(acceptedConst);
    acceptedBadge = sharedPrefs.acceptedBadgeNumber ?? 0;
    historyBadge = acceptedBadge + pendingBadge + cancelBadge + completedBadge;
    notifyListeners();
  }

  getCanceledBadge() async {
    await sharedPrefs.getCanceledBadge(canceledConst);
    cancelBadge = sharedPrefs.canceledBadgeNumber ?? 0;
    historyBadge = acceptedBadge + pendingBadge + cancelBadge + completedBadge;
    notifyListeners();
  }

  getCompletedBadge() async {
    await sharedPrefs.getCompletedBadge(completedConst);
    completedBadge = sharedPrefs.completedBadgeNumber ?? 0;
    historyBadge = acceptedBadge + pendingBadge + cancelBadge + completedBadge;
    notifyListeners();
  }

  updateBadge() async {
    await sharedPrefs.removeEstimateBadge(estimateBadgeName);
    badge = 0;
    notifyListeners();
  }

  updatePendingBadge() async {
    await sharedPrefs.removeEstimateBadge(pendingConst);
    pendingBadge = 0;
    historyBadge = pendingBadge + acceptedBadge + cancelBadge + completedBadge;
    notifyListeners();
  }

  updateAcceptedBadge() async {
    await sharedPrefs.removeEstimateBadge(acceptedConst);
    acceptedBadge = 0;
    historyBadge = pendingBadge + acceptedBadge + cancelBadge + completedBadge;
    notifyListeners();
  }

  updateCanceledBadge() async {
    await sharedPrefs.removeEstimateBadge(canceledConst);
    cancelBadge = 0;
    historyBadge = pendingBadge + acceptedBadge + cancelBadge + completedBadge;
    notifyListeners();
  }

  updateCompletedBadge() async {
    await sharedPrefs.removeEstimateBadge(completedConst);
    completedBadge = 0;
    historyBadge = pendingBadge + acceptedBadge + cancelBadge + completedBadge;
    notifyListeners();
  }
}
