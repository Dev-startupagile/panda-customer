String changeToAmPm(String time){
  String newTime = "";
  if( int.parse(time.split(":")[0]) >= 12){
    if(int.parse(time.split(":")[0]) >= 12){
      var hour =(int.parse(time.split(":")[0]) - 12).toString();
      var minute = time.split(":")[1].toString();
      if(hour.length == 1){
        hour = "0" + hour;
      }
      if(minute.length == 1){
        minute = "0"+ minute;
      }
      newTime = hour.split("-").join("0")+":"+ minute+ " PM" ;
      return newTime;

    }else if(int.parse(time.split(":")[0]) < 12){
      var hour =(int.parse(time.split(":")[0])).toString();
      var minute = time.split(":")[1].toString();
      if(hour.length == 1){
        hour = "0" + hour;
      }
      if(minute.length == 1){
        minute = "0"+ minute;
      }
      newTime = hour+":"+ minute+ " AM" ;
      return newTime;
    }

  }else{
    var newTime = "";
    if(int.parse(time.split(":")[0]) >= 10){
      var hour =(int.parse(time.split(":")[0]) - 12).toString();
      var minute = time.split(":")[1].toString();
      if(hour.length == 1){
        hour = "0" + hour;
      }
      if(minute.length == 1){
        minute = "0"+ minute;
      }
      newTime = hour.split("-").join("0")+":"+ minute+ " AM" ;
      return newTime;

    }
    var hour =(int.parse(time.split(":")[0])).toString();
    var minute = time.split(":")[1].toString();
    if(hour.length == 1){
      hour = "0" + hour;
    }
    if(minute.length == 1){
      minute = "0"+ minute;
    }
    newTime = hour+":"+ minute+ " AM" ;
    return newTime;
  }
  return "";
}