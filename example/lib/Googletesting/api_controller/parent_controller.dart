//actual
// import 'package:flutter_weko/api_controller/weko_endpoints.dart';
// import 'package:flutter_weko/services/storage.dart';
// import 'package:health/health.dart';
import 'dart:io';

import 'package:google_flutter_con3/Googletesting/services/storage.dart';
//import 'package:segmentedgoogle/services/storage.dart';

//for segmented


abstract class ParentController {
  DateTime lastUpdated = DateTime.now();
  List<String> textLog = [];
  String id = '';

  final SecureStorage secureStorage = SecureStorage();

  ParentController() {
    logAction('Class initialisation');
  }

  void assignId(String deviceId);

  void checkFirstTime() async {
    logAction('Checking first time setup');

    await secureStorage.containsKey('$id.active').then((bool exists) {
      if (exists) {
        // create secure storage value
      } else {
        // assign active variable value
      }
    });

    doFirstTimeSetup();
  }

  void doFirstTimeSetup();

  void updateData(DateTime startDate, DateTime endDate);

  void logAction(String log) {
    // print(log);
    textLog.add(log);
  }
}
