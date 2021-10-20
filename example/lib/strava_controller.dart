import 'dart:convert';

import 'package:example/parent_controller.dart';
import 'package:example/stravaData.dart';
import 'package:example/stravaHealthActivity.dart';

import 'package:example/stravasecret.dart';
import 'package:example/weko_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:strava_flutter/models/strava_auth_scopes.dart';
import 'package:strava_flutter/strava_client.dart';

class StravaController extends ParentController {
  static StravaClient client = StravaClient(secret, clientId);
  bool accessWasGranted = false;
  WekoHealthDataAPI api = WekoHealthDataAPI();

  StravaController() : super() {}

  void assignId(String deviceId) {
    id = '$deviceId.android';
    logAction('Assigned ID: $id');
  }

  void doFirstTimeSetup() async {
    _requestAuth();

    // await super.getPreferences().then((prefs) {
    //   prefs.setBool(prefKey, true);
    //   logAction('First time setup complete');
    // });
  }

  Future<void> updateData(DateTime startDate, DateTime endDate) async {
    String dateId = '${startDate.day}${startDate.month}${startDate.year}';
    _requestAuth().then((void v) {
      _fetchData(startDate, endDate).then((data) {
        print(data.returnMap(id));
        //WekoHealthDataAPI.update(data.returnMap(id));
      });
    });
  }

  Future<void> _requestAuth() async {
    if (!accessWasGranted) {
      accessWasGranted = await requestAuthorization();
      if (accessWasGranted) {
        logAction('Authorisation success');
      } else {
        logAction('Authorisation failure');
      }
    }
  }

  Future<bool> requestAuthorization() async {
    try {
      await client.authenticate(scopes: [
        StravaAuthScope.profile_read_all,
        StravaAuthScope.read_all,
        StravaAuthScope.activity_read_all
      ], redirectUrl: "stravaflutter://redirect/");
      print("hooray");
      return true;
    } catch (e) {
      print('Failure');
      return false;
    }
  }

  Future<stravaActivityPoint> _fetchData(
      DateTime startDate, DateTime endDate) async {
    List<stravaActivityPoint> healthData = [];
    stravaActivityPoint returnData = stravaActivityPoint(new Map());
    if (accessWasGranted) {
      try {
        logAction('Retrieving health data');
        var stravaToken = await client.getAccessTokenEmir();

        print(stravaToken);

        RegExp regExp1 = new RegExp(
          r'access_token":"[\w]+',
          caseSensitive: false,
          multiLine: false,
        );
        String receival = regExp1.stringMatch(stravaToken.toString());
        String extractedToken = receival.substring(15);
        var url = Uri.parse(
            'https://www.strava.com/api/v3/athlete/activities?access_token=${extractedToken}');
        http.Response response = await http.get(url);

        if (response.statusCode == 200) {
          String data = response.body;
          var decodedData = jsonDecode(data);
          healthData = (getHealthData(startDate, endDate, decodedData));
          if (healthData.length != 0) {
            stravaActivityPoint returnData = convertToWeko(healthData);
            return returnData;
          }
        }
      } catch (e) {
        print('Caught exception in getHealthDataFromTypes: $e');
      }
    } else {
      logAction('Unable to retrieve health data: no access');
    }

    return returnData;
  }
}
