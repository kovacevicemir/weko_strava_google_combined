import 'dart:async';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
//import '../../../../../../1actual/wekogooglefit2/lib/api_controller/google/google_data.dart';
//import '../../../../../../1actual/wekogooglefit2/lib/api_controller/google/google_types.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';
import 'package:googleapis/fitness/v1.dart';
//import 'package:googleapis/shared.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
//imports needed for acutal thing
// import 'package:flutter_weko/api_controller/data_types.dart';
// import 'package:flutter_weko/api_controller/unified_data.dart';
// import 'package:flutter_weko/api_controller/parent_controller.dart';
//import specific for segmented version
import '../parent_controller.dart';
import 'google_data.dart';
import 'google_types.dart';

///
/// class for signing into google, this allows you to add data scopes
///

class GoogleController extends ParentController {
  //do we even need this?
  void assignId(String deviceId) {
    //id = '$deviceId.google';
    id = '$deviceId.googleview';
    logAction('Assigned ID: $id');
  }

  //variables
  final String controllerType = 'google';
  //are we logged in
  bool accessWasGranted = false;
  late FitnessApi fitnessApi;

  //
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '[YOUR_OAUTH_2_CLIENT_ID]',
    scopes: <String>[
      //THIS IS IMPORTANT, THIS IS WHERE YOU ADD THE SCOPES YOU WANT TO GET DATA FOR

      //fitness api
      FitnessApi.fitnessActivityReadScope,
      FitnessApi.fitnessBloodPressureReadScope,

      FitnessApi.fitnessBloodGlucoseReadScope,

      FitnessApi.fitnessBodyReadScope,
      FitnessApi.fitnessBodyTemperatureReadScope,
      FitnessApi.fitnessHeartRateReadScope,
      FitnessApi.fitnessNutritionReadScope,
      FitnessApi.fitnessOxygenSaturationReadScope,
      // FitnessApi.fitnessReproductiveHealthReadScope,
      FitnessApi.fitnessSleepReadScope,
      FitnessApi.fitnessBloodPressureReadScope
    ],
  );
  //account
  GoogleSignInAccount? _currentUser;
  //user id - currently only me exists in google api
  final String userId = 'me';
  //authorised client

  //api plugin instance





  @override
  void doFirstTimeSetup() {
    // TODO: implement doFirstTimeSetup
    _requestAuth();
  }

  @override
  void updateData(DateTime startDate, DateTime endDate) {
    // TODO: implement updateData
    String dateId = '${startDate.day}${startDate.month}${startDate.year}';
    print('Date ID: $dateId');

    //ensure we are actually authenticated then fetchdata
    _requestAuth().then((void v) {
      _fetchData(startDate, endDate).then((data) {

        print("we got data!");
        GoogleHealthData googleHealthData = new GoogleHealthData();
        googleHealthData.addDataList(data);
      });
    });






  }

  /// First login for google authenication WORKING
  Future<void> _requestAuth() async {
    //checks if valid account exists and assigns it to accessWasGranted
    accessWasGranted = GoogleAcountStatus();
    print('Request auth start');
    if (!accessWasGranted) {
      // Retrieve an [auth.AuthClient] from the current [GoogleSignIn] instance.

      //actual sign in
      print('auth strt');
      _googleSignIn.signInSilently();
      await _googleSignIn.signIn();

      //
      print('auth f');
      //setup client
      final auth.AuthClient? client = await _googleSignIn.authenticatedClient();
      assert(client != null, 'Authenticated client missing!');

      //check and update acesswasgranted var
      accessWasGranted = GoogleAcountStatus();

      //instance of fitnessapi to use (requires client hence it is only setup now)
      fitnessApi = FitnessApi(client!);

      //ensure access was actually granted
      if (accessWasGranted) {
        logAction('Google Authorisation success');
      } else {
        logAction('Google Authorisation failure');
      }
    }

    print('Request auth end');
  }

  ///Fetch data
  ///
  Future<List<Dataset>> _fetchData(DateTime startDate, DateTime endDate)
  async {
    List<Dataset> googleHealthData = [];


    //converts datetimes to ms since epoch - UNIX format
    String startDateMS = startDate.microsecondsSinceEpoch.toString() + '000';
    String endDateMS = endDate.microsecondsSinceEpoch.toString() + '000';
    //final timestamp to be searched
    String dataTimeMS = startDateMS + '-' + endDateMS;

    //if there is an authenticated user
    if (accessWasGranted) {
      //Dataset currentdata = await fitnessApi.users.dataSources.datasets.get(userId, "derived:com.google.step_count.delta:com.google.android.gms:merge_step_deltas", dataTimeMS);
      //final Dataset currentdata = await fitnessApi.users.dataSources.datasets.get('me',"derived:com.google.step_count.delta:com.google.android.gms:merge_step_deltas", "1633392000000000000-1633564800000000000");
      //Dataset currentdata = await fitnessApi.users.dataSources.datasets.get('me',"derived:com.google.weight:com.google.android.gms:merge_weight", "1633392000000000000-1633564800000000000");

      //print(currentdata.toJson().toString());
      try {

        Map<String?, List<DataPoint>?> googleHealthPoints = {};

        //fitnessApi.users.dataSources.get(userId, dataSourceId)
        for(int i = 0; i < GoogleTypes.derivedValues.length ; i++) {
          String type = GoogleTypes.derivedValues[i];
          print('------------');
          print(type);
          Dataset currentdata = await fitnessApi.users.dataSources.datasets.get(userId, type, dataTimeMS);
          //currentdata.dataSourceId
          print(currentdata.toJson().toString());

          //sends data to google_data which handles data transfer and format
          googleHealthData.add(currentdata);

        }



        // GoogleTypes.GoogleHealthRequests.forEach((k, v) async {
        //   if (v != null)
        //     {
        //       print(v);
        //       //await fitnessApi.users.dataSources.datasets.get('me',v,dataTimeMS);
        //       Dataset currentdata = await fitnessApi.users.dataSources.datasets.get(userId, v, dataTimeMS);
        //       print(currentdata.toJson().toString());
        //
        //
        //       //googleHealthPoints.update(currentdata.dataSourceId, currentdata.point);
        //     }
        //
        // });

        //fitnessApi.users.dataSources.

        


        logAction('Retrieving google health data');
      }
      catch (e) {
        print('Caught exception in getHealthDataFromTypes: $e');
      }
    }
    else {
      logAction('Unable to retrieve google health data: no access');
    }

    return googleHealthData;
  }

  /// Get account status,
  /// if current user exists return true,
  /// if current user does not exist return false
  ///
  bool GoogleAcountStatus() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      {
        _currentUser = account;
      }
    });

    if (_currentUser != null) {
      return true;
    }

    return false;
  }

  ///
  ///login and logout handle
  ///
  Future<void> _handleSignIn() async {
    //IMPLIMENTED
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();
}
