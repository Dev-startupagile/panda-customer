String? newString(String oldString, int n) {
  if (oldString.length >= n) {
    return oldString.substring(oldString.length - n);
  }
  return null;
}

String adder(int num1, int num2) {
  return (num1 + num2).toString();
}

getStreet(description) {
  return description.split(",")[0];
}

getCity(description) {
  return description.split(",")[1];
}

getState(description) {
  return description.split(",")[2];
}
