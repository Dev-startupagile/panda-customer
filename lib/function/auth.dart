
import 'package:panda/function/shared_prefs.dart';

class AuthFunc{

  final sharedPrefs = SharedPrefs();

  Future<bool> checkIsAuthenticated() async {
    await  sharedPrefs.getToken();
    if (sharedPrefs.token != null) {
      return true;
    }
    return false;
  }


  Future<bool> isFirstTimeLogedIn() async {
    await  sharedPrefs.getIsFirstLogin();
    if (sharedPrefs.isFirstTimeLogin != null) {
      return true;
    }
    return false;
  }

  Future<bool> isAllTabClicked() async {
    await  sharedPrefs.getIsAllTabClicked();
    if (sharedPrefs.isAllTabClicked != null) {
      return true;
    }
    return false;
  }
}