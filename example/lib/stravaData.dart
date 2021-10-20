import 'package:example/stravaHealthActivity.dart';

List<stravaActivityPoint> getHealthData(
    DateTime startDate, DateTime endDate, var input) {
  List<int> todayActivityList =
      findActivitiesDateRange(startDate, endDate, input);
  List<stravaActivityPoint> Activitytypes = <stravaActivityPoint>[];
  for (int i = 0; i < todayActivityList.length; i++) {
    Activitytypes.add(stravaActivityPoint(input[todayActivityList[i]]));
  }
  print(todayActivityList.length);
  if (todayActivityList.length == 0) {
    print("NO DATA FOR TODAY");
  } else {
    print("Found Activity");
  }
  return Activitytypes;
}

List<int> findActivitiesDateRange(
    DateTime startDate, DateTime endDate, var data) {
  List<int> todayActivity = <int>[];
  for (int i = 0; i < data.length; i++) {
    if (checkDate(startDate, endDate, data[i])) {
      print(checkDate(startDate, endDate, data[i]));
      todayActivity.add(i);
    }
  }
  return todayActivity;
}

bool checkDate(DateTime startDate, DateTime endDate, var activity) {
  for (final name in activity.keys) {
    final value = activity[name];
    if (name == 'start_date_local') {
      print(value.substring(0, 10));
      DateTime activityDate = new DateTime(
          int.parse(value.substring(0, 4)),
          int.parse(value.substring(5, 7)),
          int.parse(value.substring(8, 10)) + 1,
          1);
      if (activityDate.isAfter(startDate) && activityDate.isBefore(endDate)) {
        return true;
      }
    }
  }
  return false;
}

stravaActivityPoint convertToWeko(List<stravaActivityPoint> activityList) {
  print("converting");
  num heartcount = 0;
  Map sendMap = Map();
  stravaActivityPoint sendData = stravaActivityPoint(sendMap);
  for (int i = 0; i < activityList.length; i++) {
    sendData.addValues(
        activityList[i].search('kilojoules'), 'activeEnergyBurned');
    sendData.addValues(activityList[i].search('moving_time'), 'moveMinutes');
    sendData.addValues(activityList[i].search('distance') / 1000,
        activityList[i].calculateDistanceType());
    sendData.addValues(
        (activityList[i].search('average_cadence') *
                activityList[i].search('moving_time') /
                60)
            .round(),
        'steps');
    sendData.addValues(
        activityList[i].search('average_heartrate'), 'average_heartrate');
    if (activityList[i].isNull('average_heartrate')) {
      heartcount++;
    }
  }
  sendData.avgValues(heartcount, 'average_heartrate');
  sendData.avgValues(60, 'moveMinutes');
  sendData.checkNullAll();
  return sendData;
}

  // String? checkActivity(var activity) {
  //   for (final name in activity.keys) {
  //     final value = activity[name];
  //     if (name == 'type') {
  //       return value;
  //     }
  //   }
  //   return null;
  // }