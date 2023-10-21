
bool is8Char(String password){
  if(password.length >= 8){
    return true;
  }else{
    return false;
  }

}

bool containsUpperCase(String password){
  if(password.contains(RegExp(r'[A-Z]'))){
    return true;
  }else{
    return false;
  }
}

bool containsLowerCase(String password){
  if(password.contains(RegExp(r'[a-z]'))){
    return true;
  }else{
    return false;
  }
}

bool containsNumb(String password){
  if(password.contains(RegExp(r'[0-9]'))){
    return true;
  }else{
    return false;
  }
}

bool containsSymbols(String password){
  final symbols = RegExp(r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+='"'"']');
  if(password.contains(symbols)){
    return true;
  }else{
    return false;
  }

}