//actual
// import 'package:flutter_weko/api_controller/apple/apple_controller.dart';
// import 'package:flutter_weko/api_controller/parent_controller.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
//for segmented
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_flutter_con3/Googletesting/api_controller/parent_controller.dart';
//import 'package:segmentedgoogle/api_controller/parent_controller.dart';
//import 'package:segmentedgoogle/api_controller/apple_controller.dart';




class APIManager {
  List<ParentController> activeControllers = [];
  String? deviceId;

  APIManager() {
    _getUserId();
  }

  void setup() {
    if (Platform.isIOS) {
      //activeControllers.add(new AppleController());
    }

    if (Platform.isAndroid) {
      // activeControllers.add(new OtherController());
    }

    activeControllers.forEach((api) {
      api.assignId(deviceId ?? '68');
      api.checkFirstTime();
    });
  }

  void updateData() {
    var now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month - 1, now.day);
    DateTime endDate = DateTime(now.year, now.month, now.day + 1);

    activeControllers.forEach((api) {
      api.updateData(startDate, endDate);
    });
  }

  Future<void> updateHistoricalData() async {}

  Future<void> _getUserId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      await deviceInfo.iosInfo.then((var iosDeviceInfo) {
        print('Device info: ${iosDeviceInfo.identifierForVendor}');
        deviceId = iosDeviceInfo.identifierForVendor;
      });
    } else {
      await deviceInfo.androidInfo.then((var androidDeviceInfo) {
        print('Device info: ${androidDeviceInfo.androidId}');
        deviceId = androidDeviceInfo.androidId;
      });
    }
  }
}
