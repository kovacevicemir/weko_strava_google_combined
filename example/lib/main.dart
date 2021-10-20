import 'dart:convert';
import 'dart:developer';

import 'package:example/stravaWekoFunctions.dart';
import 'package:example/strava_controller.dart';

import 'api_manager.dart';
import 'new_api_examples.dart';
import 'package:flutter/material.dart';
import 'package:strava_flutter/strava.dart';
// To remove # at the end of redirect url when in web mode (not mobile)
// This is a web only package
// import 'dart:html' as html;

import 'package:http/http.dart' as http;

// Used by example

//Strava strava;
APIManager apiManager = APIManager();
Future<void> main() async {
  runApp(MyApp());
  //await apiManager.setup();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strava Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StravaFlutterPage(title: 'Strava Flutter Demo'),
    );
  }
}

class StravaFlutterPage extends StatefulWidget {
  StravaFlutterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StravaFlutterPageState createState() => _StravaFlutterPageState();
}

class _StravaFlutterPageState extends State<StravaFlutterPage> {
  var myData = null;

  @override
  void initState() {
    setState(() {
      // html.window.history.pushState(null, "home", '/');
    });
    super.initState();
  }

  // void exampleStrava() {
  //   example(secret);
  // }

  // void exampleSeg() {
  //   exampleSegment(secret);
  // }

  // void permissions() {
  //   testPermissions(secret);
  // }

  ///
  /// Example of dart code to use Strava API
  ///
  /// set isInDebug to true in strava init to see the debug info
  // void example(String secret) async {
  //   bool isAuthOk = false;
  //
  //   final strava = Strava(true, secret);
  //   final prompt = 'auto';
  //
  //   isAuthOk = await strava.oauth(
  //       clientId,
  //       'activity:write,activity:read_all,profile:read_all,profile:write',
  //       secret,
  //       prompt);
  //
  //   if (isAuthOk) {
  //     // Get the zones related to the logged athlete
  //     // Zone _zone = await strava.getLoggedInAthleteZones();
  //     // if (_zone.fault.statusCode != 200) {
  //     //   print(
  //     //       'Error in getLoggedInAthleteZones  ${_zone.fault.statusCode}  ${_zone.fault.message}');
  //     // } else {
  //     //   _zone.infoZones.zones.forEach(
  //     //       (zone) => print('getLoggedInAthleteZones ${zone.min} ${zone.max}'));
  //     // }
  //
  //     // Activity 3226262796 with totalElevationGain to 0
  //     DetailedActivity _activityPhoto =
  //         await strava.getActivityById('3288393232');
  //
  //     // Get the photo of an activity
  //     // PhotoActivity _photo = await strava.getPhotosFromActivityById('3288393232');
  //
  //     // Create an new activity
  //     String _startDate = '2020-02-18 10:02:13';
  //     DetailedActivity _newActivity = await strava.createActivity(
  //         'Test_Strava_Flutter', 'ride', _startDate, 3600,
  //         distance: 1555, description: 'This is a strava_flutter test');
  //     if (_newActivity.fault.statusCode != 201) {
  //       print(
  //           'Error in createActivity ${_newActivity.fault.statusCode}  ${_newActivity.fault.message}');
  //     } else {
  //       print('createActivity  ${_newActivity.name}');
  //     }
  //
  //     // Type of expected answer:
  //     // {"id":25707617,"username":"patrick_ff","resource_state":3,"firstname":"Patrick","lastname":"FF",
  //     // "city":"Le Beausset","state":"Provence-Alpes-Côte d'Azur","country":"France","sex":null,"premium"
  //     DetailedAthlete _athlete = await strava.getLoggedInAthlete();
  //     if (_athlete.fault.statusCode != 200) {
  //       print(
  //           'Error in getloggedInAthlete ${_athlete.fault.statusCode}  ${_athlete.fault.message}');
  //     } else {
  //       print('getLoggedInAthlete ${_athlete.firstname}  ${_athlete.lastname}');
  //     }
  //
  //     // Type of expected answer
  //     //  {"biggest_ride_distance":156733.0,"biggest_climb_elevation_gain":null,"recent_ride_totals":{"count":2,"distance":111427.7001953125,
  //     // "moving_time":17726,"elapsed_time":23181,"elevation_gain":1354.5838375091553,"achievement_count":0},"recent_run_to
  //     Stats _stats = await strava.getStats(_athlete.id);
  //     if (_stats.fault.statusCode != 200) {
  //       print(
  //           'Error in getStats ${_stats.fault.statusCode}    ${_stats.fault.message}');
  //     } else {
  //       print(
  //           'getStats ${_stats.ytdRideTotals.distance} ${_stats.ytdRideTotals.elevationGain}   ${_stats.allSwimTotals.distance}');
  //     }
  //
  //     // A long list of races per city
  //     // Starting by Walt Disney World Marathonr
  //     List<RunningRace> _listRunningRaces =
  //         await strava.getRunningRaces('2019');
  //     if ((_listRunningRaces == null) ||
  //         (_listRunningRaces[0].fault.statusCode != 200)) {
  //       print(
  //           'Error in getRunningRaces: ${_listRunningRaces[0].fault.statusCode}    ${_listRunningRaces[0].fault.message}');
  //     } else {
  //       print('getRunningRaces ${_listRunningRaces[0].name}');
  //     }
  //
  //     // id corresponding to BMW Berlin Marathon 29th Sept 2019
  //     RunningRace _race = await strava.getRunningRaceById('2724');
  //     if (_race.fault.statusCode != 200) {
  //       print(
  //           'Error in getRunningRaceById  ${_race.fault.statusCode}    ${_race.fault.message}');
  //     } else {
  //       print('getRunningRaceById $_race');
  //     }
  //
  //     // Change weight of the loggedAthlete in profile (in kg)
  //     DetailedAthlete _athlete2 = await strava.updateLoggedInAthlete(80);
  //     if (_athlete2.fault.statusCode != 200) {
  //       print(
  //           'Error in updateLoggedInAthlete ${_athlete2.fault.statusCode}  ${_athlete2.fault.message}');
  //     } else {
  //       print('getRunningRaceById $_athlete2');
  //     }
  //
  //     /// Gear should be owned by the loggedIn Athleted
  //     /// Type of expected answer:
  //     /// {"id":"b4366285","primary":true,"name":"Roubaix Specialized","resource_state":3,"distance":461692.0,
  //     /// "brand_name":"Specialized","model_name":"Roubaix Expert","frame_type":3,"description":"So comfortable!"}
  //     // Gear _gear = await strava.getGearById("b4366285");
  //     // if (_gear.fault.statusCode != 200) {
  //     //   print(
  //     //       'error code getGearById  ${_gear.fault.statusCode}  ${_gear.fault.message}');
  //     // } else {
  //     //   print('getGearById $_gear');
  //     // }
  //
  //     // IMPORTANT ------
  //     //  You have to join this club to do the test
  //     final clubStravaMarseille = '226910';
  //
  //     /// Answer expected:
  //     /// {"id":226910,"resource_state":3,"name":"STRAVA Marseille ",
  //     /// "profile_medium":"https://dgalywyr863hv.cloudfront.net/pictures/clubs/226910/5003423/3/medium.jpg","profile":"https://dgalywyr863hv.cloudfront.net/pictures/clubs/226910/5003423/3/larg
  //     // Club _club = await strava.getClubById(clubStravaMarseille);
  //     // if (_club.fault.statusCode != 200) {
  //     //   print(
  //     //       'error code getClubById  ${_club.fault.statusCode}  ${_club.fault.message}');
  //     // } else {
  //     //   print('getClubById $_club');
  //     // }
  //
  //     /// List the member of Strava club
  //     /// Expected answer (should start like this):
  //     ///  [{"resource_state":2,"firstname":"Adam","lastname":"Š.","membership":"member",
  //     /// "admin":false,"owner":false},{"resource_state":2,"firstname":"Alex","lastname":"M.","membership"
  //
  //     List<SummaryAthlete> _listMembers = await strava.getClubMembersById('1');
  //     // List<SummaryAthlete> _listMembers = await strava.getClubMembersById(_club.id.toString());
  //
  //     // if (_listMembers[0].fault.statusCode != 200) {
  //     //   print(
  //     //       'error code getClubById  ${_club.fault.statusCode}  ${_club.fault.message}');
  //     // } else {
  //     //   print('getClubMembersById ');
  //     //   _listMembers.forEach((member) => print(
  //     //       '${member.firstname}   ${member.lastname}  ${member.id} ${member.membership}'));
  //     // }
  //
  //     // List<SummaryActivity> _listSumm =
  //     //     await strava.getClubActivitiesById(clubStravaMarseille);
  //     // if (_listSumm[0].fault.statusCode != 200) {
  //     //   print(
  //     //       'error code getClubById  ${_club.fault.statusCode}  ${_club.fault.message}');
  //     // } else {
  //     //   print('getClubActivitiesById ');
  //     //   _listSumm.forEach((activity) =>
  //     //       print('${activity.name}   ${activity.totalElevationGain}'));
  //     // }
  //
  //     /// You have to put an id of one activity of the logged Athlete
  //     /// You can find the id of one activity looking at your web
  //     ///  like https://www.strava.com/activities/2130215349
  //
  //     // Activity 3226262796 with totalElevationGain to 0
  //     DetailedActivity _activity = await strava.getActivityById('3234043107');
  //
  //     // Activity 2704301316 totalElevationGain 1360.1
  //     // DetailedActivity _activity = await strava.getActivityById('3234026164');
  //     if (_activity.fault.statusCode != 200) {
  //       print(
  //           'Error in getActivityById: ${_activity.fault.statusCode} - ${_activity.fault.message}');
  //     } else {
  //       print(
  //           'getActivityById ${_activity.name}  Total Elevation Gain ${_activity.totalElevationGain}');
  //     }
  //   }
  // }

  // Future<Fault> upload() async {
  //   print('Trying to upload');
  //
  //   showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       });
  //
  //   final Fault fault = await exampleUpload(secret);
  //   Navigator.pop(context);
  //   return fault;
  // }

  // Future<http.Response> fetchAlbum() {
  //   return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  // }

  void testingFetch() async {
    apiManager.updateActiveData();
    // var stravaToken = await NewApiExamples.client.getAccessTokenEmir();
    // print(stravaToken);
    //
    // print(stravaToken.runtimeType);
    //
    // RegExp regExp1 = new RegExp(
    //   r'access_token":"[\w]+',
    //   caseSensitive: false,
    //   multiLine: false,
    // );
    // String receival = regExp1.stringMatch(stravaToken.toString());
    // print(receival);
    // var extractedToken = receival.substring(15);
    //
    // // var emirUrl = 'https://www.strava.com/api/v3/athlete/activities?access_token=${extractedToken}';
    // // print(emirUrl);
    //
    // var url = Uri.parse('https://www.strava.com/api/v3/athlete/activities?access_token=${extractedToken}');
    // http.Response response = await http.get(url);
    // try {
    //   if (response.statusCode == 200) {
    //     String data = response.body;
    //     var decodedData = jsonDecode(data);
    //     //setState((){ myData = decodedData;});
    //     print(decodedData);
    //     extractData(decodedData);
    //     // List<int> todayActivityList=findTodayActivities(decodedData);
    //     // num totalcal=0;
    //     // num totalwalk=0;
    //     // num totaltime=0;
    //     // num maxheartrate=0;
    //     // if (todayActivityList.length==0){print("NO DATA FOR TODAY");}
    //     // else {
    //     //   for (int i = 0; i < todayActivityList.length; i++) {
    //     //     totalcal += checkKeyVal(decodedData[i], 'kilojoules');
    //     //     totalwalk += checkKeyVal(decodedData[i], 'distance');
    //     //     totaltime += checkKeyVal(decodedData[i], 'moving_time');
    //     //     var heartrate = checkKeyVal(decodedData[i], 'max_heartrate');
    //     //     if (heartrate > maxheartrate) {
    //     //       maxheartrate = heartrate;
    //     //     };
    //     //   }
    //     //   if (totalcal != 0) {
    //     //     sendMap['"activeEnergyBurned"'] = '"' + totalcal.toString() + '"';
    //     //   }
    //     //   if (totalwalk != 0) {
    //     //     sendMap['"distanceWalkingRunning"'] =
    //     //         '"' + totalwalk.toString() + '"';
    //     //   }
    //     //   /*num totalminutes=totaltime/60;
    //     // totalminutes=totalminutes.floor();
    //     // num totalseconds=totaltime%60;*/
    //     //   num totalminutes = totaltime / 60;
    //     //   //String totalMin="$totalminutes:$totalseconds";
    //     //   if (totaltime != 0) {
    //     //     sendMap['"moveMinutes"'] = '"' + totalminutes.toString() + '"';
    //     //   }
    //     //   if (maxheartrate != 0) {
    //     //     sendMap['"highHeartRateEvent"'] =
    //     //         '"' + maxheartrate.toString() + '"';
    //     //   }
    //     //   sendMap['"dateReceived"'] = '"' + getDateString().toString() + '"';
    //     //   sendData(sendMap);
    //     // }
    //
    //
    //     //String  identifier =await UniqueIdentifier.serial;
    //     //sendMap["deviceID"]=await UniqueIdentifier.serial;
    //
    //
    //     //for (var i=0; i<decodedData.length; i++){
    //     //decodedData[0].forEach((k,v) => if(k=='start_date'){print('${k}: ${v}')});
    //     //}
    //     //var listDecode=decodedData.toList();
    //     //print(decodedData[0].runtimeType);
    //     //print(todayActivityList);
    //     //print(decodedData[0].keys);
    //     //print(decodedData[0].getKey());
    //     //String gotDate=decodedData[0].forEach((k,v) => checkDate(k,v));
    //     //print(gotDate);
    //     //RegExp regExp2 = new RegExp(
    //       //r"a",
    //       //caseSensitive: false,
    //       //multiLine: false,
    //     //);
    //     //String receival2 = regExp2.stringMatch(decodedData[0]);
    //     //decodedData[0]['created_at'] = 'U1oo1';
    //     //print(receival2["created_at"];
    //
    //   } else {
    //     print("FAILED1");
    //   }
    // } catch (e) {
    //  print(e);
    // }
  }

  Future<http.Response> sendData(var datamapping) async {
    var url = Uri.parse(
        "https://i43bvzq8df.execute-api.ap-southeast-2.amazonaws.com/dev/healthData");
    String healthData = json.encode(datamapping);
    String postbody = '{"action": "create","payload":$datamapping}';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final WekoData = await http.post(url, body: postbody, headers: headers);
    final responseJson = json.decode(WekoData.body);
    print(responseJson);
    return WekoData;
  }

  List<int> findTodayActivities(var data) {
    List<int> todayActivity = new List();
    for (int i = 0; i < data.length; i++) {
      if (checkDate(data[i])) {
        todayActivity.add(i);
      }
    }
    return todayActivity;
  }

  String getDateString() {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    int yearCurrent = now.year;
    int monthCurrent = now.month;
    int dayCurrent = now.day;
    String strMonth = monthCurrent.toString().padLeft(2, '0');
    String strDay = dayCurrent.toString().padLeft(2, '0');
    int hourcurrent = now.hour;
    int mincurrent = now.minute;
    int seccurrent = now.second;
    String timeZone = date.timeZoneOffset.toString().substring(0, 5);
    String dateformat =
        '$yearCurrent-$strMonth-$strDay $hourcurrent:$mincurrent:$seccurrent+$timeZone';
    return dateformat;
  }

//Input an activity and checks if the date is for today.
  bool checkDate(var activity) {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    int yearCurrent = now.year;
    int monthCurrent = now.month;
    int dayCurrent = now.day;
    String strMonth = monthCurrent.toString().padLeft(2, '0');
    String strDay = dayCurrent.toString().padLeft(2, '0');
    String todayDate = '$yearCurrent-$strMonth-$strDay';
    for (final name in activity.keys) {
      final value = activity[name];
      //print('$name,$value'); // prints entries like "AED,3.672940"
      if (name == 'start_date') {
        if (value.substring(0, 10) == todayDate) {
          return true;
        }
      }
    }
    return false;
  }

  List<String> findActivities(var data, var valid_dates) {
    List<String> Activitytypes = new List();
    for (int i = 0; i < valid_dates.length; i++) {
      Activitytypes.add(checkActivity(data[valid_dates[i]]));
    }
    return Activitytypes;
  }

  String checkActivity(var activity) {
    for (final name in activity.keys) {
      final value = activity[name];
      //print('$name,$value'); // prints entries like "AED,3.672940"
      if (name == 'type') {
        //if value
        return value;
      }
    }
    return null;
  }

  num checkKeyVal(var data, String Comparison) {
    for (final name in data.keys) {
      final value = data[name];
      //print('$name,$value'); // prints entries like "AED,3.672940"
      if (name == Comparison) {
        return value;
      }
    }
    return 0;
  }

  // void deAuthorize() async {
  //   // need to get authorized before (valid token)
  //   final strava = Strava(
  //     true, // to get disply info in API
  //     secret, // Put your secret key in secret.dart file
  //   );
  //   final fault = await strava.deAuthorize();
  // }

  Future<void> refactoredExample() async {
    await apiManager.setup();
  }

  // @override
  // void dispose() {
  //   strava.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(''),
            Text('Authentication'),
            Text('with refactored Apis'),
            RaisedButton(
              child: Text('Refactored'),
              // onPressed: exampleStrava,
              onPressed: refactoredExample,
            ),
            Text(''),
            Text('Authentication'),
            Text('with segments Apis'),
            RaisedButton(
              child: Text('Segments'),
              // onPressed: exampleStrava,
              onPressed: refactoredExample,
            ),
            Text(''),
            Text('Authentication'),
            Text('with other Apis'),
            RaisedButton(
              child: Text('strava_flutter'),
              onPressed: refactoredExample,
            ),
            Text(''),
            Text(''),
            Text('Upload with authentication'),
            RaisedButton(
              child: Text('testFetching'),
              onPressed: testingFetch,
            ),
            Text(''),
            Text(''),
            Text('Test insufficient permissions'),
            RaisedButton(
              child: Text('permissions'),
              onPressed: refactoredExample,
            ),
            Text(' '),
            Text(''),
            Text("$myData"),
            Text(''),
            Text('Push this button'),
            Text(
              'to revoke/DeAuthorize Strava user',
            ),
            RaisedButton(
              child: Text('DeAuthorize'),
              onPressed: refactoredExample,
            ),
          ],
        ),
      ),
    );
  }
}
