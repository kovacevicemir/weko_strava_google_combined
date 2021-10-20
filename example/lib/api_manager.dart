import 'package:example/parent_controller.dart';
import 'package:example/strava_controller.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class APIManager {
  List<ParentController> activeControllers = [];
  DateTime activeDay = DateTime.now();
  DateTime lastUpdated = DateTime.now();
  String deviceId = '';

  APIManager();

  Future<void> setup() async {
    deviceId = await getUserId();

    DateTime now = DateTime.now();
    activeDay = DateTime(now.year, now.month, now.day);
    // IOS only Controllers
    if (Platform.isIOS) {
      //activeControllers.add(new AppleController());
    }

    // Android only controllers
    if (Platform.isAndroid) {
      activeControllers.add(new StravaController());
      // activeControllers.add(new AndroidController());
    }

    // Global controllers
    // activeControllers.add(new GlobalController));

    // Finish setup of each (id) and run initial setup (if any)
    activeControllers.forEach((api) {
      api.assignId(deviceId ?? '68');
      api.doFirstTimeSetup();
    });

    // Update today's data
    //updateActiveData();

    // Update this week's data
    //updateRecentData();
  }

  Future<void> iosBackground() async {
    checkOvernightUpdate();
  }

  Future<void> focusGained() async {
    DateTime now = DateTime.now();
    Duration diff = now.difference(lastUpdated);

    // Check overnight in case backgrounding tasks fail
    checkOvernightUpdate();

    // Update every 5 minutes when user is actively checking
    if (diff.inMinutes >= 5) {
      updateActiveData();
    }
  }

  Future<void> checkOvernightUpdate() async {
    DateTime now = DateTime.now();
    Duration diff = now.difference(activeDay);

    // Return method if same day
    if (diff.inHours < 24) {
      return;
    }

    // Final update for previous day
    DateTime startDate = activeDay;
    DateTime endDate = activeDay.add(Duration(days: 1));
    for (int i = 0; i < activeControllers.length; i++) {
      var api = activeControllers[i];
      api.logAction('updating overnight');
      api.updateData(startDate, endDate);
    }

    // Set activeDay to next day
    activeDay = DateTime(now.year, now.month, now.day);
  }

  Future<void> updateActiveData() async {
    DateTime endDate = activeDay.add(Duration(days: 1));
    for (int i = 0; i < activeControllers.length; i++) {
      var api = activeControllers[i];
      api.logAction('updating daily');
      api.updateData(activeDay, endDate);
    }

    lastUpdated = DateTime.now();
  }

  Future<void> updateRecentData() async {
    for (int i = 0; i < activeControllers.length; i++) {
      var api = activeControllers[i];
      api.logAction('updating weekly');

      for (int j = 1; j <= 7; j++) {
        DateTime startDate = activeDay.subtract(Duration(days: i));
        DateTime endDate = startDate.add(Duration(days: 1));
        api.updateData(startDate, endDate);
      }
    }
  }

  Future<void> updateHistoricalData() async {}

  static Future<String> getUserId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Device info: ${iosInfo.identifierForVendor}');
      return iosInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Device info ${androidInfo.androidId}');
      return androidInfo.androidId;
    }
  }
}
