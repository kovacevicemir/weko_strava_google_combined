import 'dart:convert';
import 'dart:developer';

import 'new_api_examples.dart';
import 'package:flutter/material.dart';
import 'package:strava_flutter/strava.dart';
// import 'dart:html' as html;

import 'examples.dart';

import 'secret.dart';

import 'permissions.dart';

import 'package:strava_flutter/strava.dart';

import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';


// Used by example

void extractData(decodedData) async{
  List<int> todayActivityList=findTodayActivities(decodedData);
  print(todayActivityList);
  print(todayActivityList.length);
  if (todayActivityList.length==0){print("NO DATA FOR TODAY");}
  else {
    await editData(populateData( todayActivityList, decodedData));
  }
}
//device.compony.date

Future<http.Response> sendData(var datamapping) async {
  var url= Uri.parse("https://i43bvzq8df.execute-api.ap-southeast-2.amazonaws.com/dev/healthData");

  String postbody='{"action": "create","payload":$datamapping}';
  print(postbody);
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json',
  };
  final WekoData = await http.post(url, body:postbody, headers: headers);
  final responseJson = json.decode(WekoData.body);
  print(responseJson);
  return WekoData;
}

Future<http.Response> editData(var datamapping) async {
  var url= Uri.parse("https://i43bvzq8df.execute-api.ap-southeast-2.amazonaws.com/dev/healthData");
  String deviceId=await _getUserId();
  String deviceID=deviceId+".strava";
  //int deviceID=48;
  Map datamapsort=new Map();
  datamapsort['"id"'] = deviceID.toString() ;
  datamapsort.addAll(datamapping);
  String postbody='{"action": "update","payload":$datamapsort}';
  print(postbody);
  Map<String,String> headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json',
  };
  final WekoData = await http.post(url, body:postbody, headers: headers);
  final responseJson = json.decode(WekoData.body);
  print(responseJson);
  return WekoData;
}

Map populateData(var todayActivityList, var decodedData){
  var sendMap=Map();
  num totalcal=0;
  num totalwalk=0;
  num totalswim=0;
  num totalride=0;
  num totaltime=0;
  num maxheartrate=0;
  for (int i = 0; i < todayActivityList.length; i++) {
    totalcal += checkKeyVal(decodedData[i], 'kilojoules');
    String exType=convertActivityType(checkKeyString(decodedData[i], 'type'));
    print(exType);
    if(exType=='bikeDistance'){
      totalride += checkKeyVal(decodedData[i], 'distance');
    }
    else if(exType=='swimDistance'){
      totalswim += checkKeyVal(decodedData[i], 'distance');
    }
    else if (exType=='distanceWalkingRunning'){
      totalwalk += checkKeyVal(decodedData[i], 'distance');
    }
    totaltime += checkKeyVal(decodedData[i], 'moving_time');
    var heartrate = checkKeyVal(decodedData[i], 'max_heartrate');
    if (heartrate > maxheartrate) {
      maxheartrate = heartrate;
    }
  }
  if (totalcal != 0) {
    sendMap['"activeEnergyBurned"'] = '"' + totalcal.toString() + '"';
  }
  if (totalswim != 0) {
    sendMap['"swimDistance"'] =
        '"' + totalswim.toString() + '"';
  }
  if (totalride != 0) {
    sendMap['"bikeDistance"'] =
        '"' + totalride.toString() + '"';
  }
  if (totalwalk != 0) {
    sendMap['"distanceWalkingRunning"'] =
        '"' + totalwalk.toString() + '"';
  }
  num totalminutes = totaltime / 60;
  if (totaltime != 0) {
    sendMap['"moveMinutes"'] = '"' + totalminutes.toString() + '"';
  }
  if (maxheartrate != 0) {
    sendMap['"highHeartRateEvent"'] =
        '"' + maxheartrate.toString() + '"';
  }
  return sendMap;
}

List<int>findTodayActivities(var data) {
  List<int> todayActivity = new List();
  for (int i=0; i<data.length; i++){
    if (checkDate(data[i])){
      print(checkDate(data[i]) );
      todayActivity.add(i);
    }
  }
  return todayActivity;
}

String getDateString(){
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
  int yearCurrent =now.year;
  int monthCurrent =now.month;
  int dayCurrent =now.day;
  String strMonth=monthCurrent.toString().padLeft(2, '0');
  String strDay=dayCurrent.toString().padLeft(2, '0');
  int hourCurrent=now.hour;
  int minCurrent=now.minute;
  int secCurrent=now.second;
  String timeZone= date.timeZoneOffset.toString().substring(0,5);
  String dateformat= '$yearCurrent-$strMonth-$strDay $hourCurrent:$minCurrent:$secCurrent+$timeZone';
  return dateformat;
}
//Input an activity and checks if the date is for today.
bool checkDate(var activity){
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);

  int yearCurrent =now.year;
  int monthCurrent =now.month;
  int dayCurrent =now.day;
  String strMonth=monthCurrent.toString().padLeft(2, '0');
  String strDay=dayCurrent.toString().padLeft(2, '0');
  String todayDate='$yearCurrent-$strMonth-$strDay';
  for (final name in activity.keys) {
    final value = activity[name];
    //print('$name,$value'); // prints entries like "AED,3.672940"
    if(name== 'start_date_local'){
      print(value.substring(0, 10));
      DateTime activityDate = new DateTime(
          int.parse(value.substring(0, 4)),
          int.parse(value.substring(5, 7)),
          int.parse(value.substring(8, 10)));
      print(activityDate);
      if(value.substring(0,10)== todayDate){
        return true;
      }
    }
  }
  return false;
}

List findActivities(var data, var valid_dates){
  List<dynamic> Activitytypes = new List();
  for (int i=0; i<valid_dates.length; i++){
    Activitytypes.add(checkActivity(data[valid_dates[i]]));
  }
  return Activitytypes;
}

String checkActivity(var activity){
  for (final name in activity.keys) {
    final value = activity[name];
    //print('$name,$value'); // prints entries like "AED,3.672940"
    if(name== 'type'){
      //if value
      return value;
    }
  }
  return null;
}

String convertActivityType(var activityType) {
  if(activityType=='EBikeRide'||activityType=='Handcycle'||activityType=='Elliptical'||activityType=='Ride'||activityType=='Velomobile'||activityType=='VirtualRide'){
    return 'bikeDistance';
  }
  else if (activityType=='Walk'||activityType=='Hike'||activityType=='Run'||activityType=='VirtualRun'){
    return 'distanceWalkingRunning';
  }
  else if (activityType=='Swim'){
    return 'swimDistance';
  }
  else{
    return null;
  }

}

num checkKeyVal(var data, String Comparison) {
  for (final name in data.keys) {
    final value = data[name];
    if(name== Comparison){
      return value;
    }
  }
  return 0;
}

String checkKeyString(var data, String Comparison) {
  for (final name in data.keys) {
    final value = data[name];
    if(name== Comparison){
      return value;
    }
  }
  return null;
}

Future<String> _getUserId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId;
}