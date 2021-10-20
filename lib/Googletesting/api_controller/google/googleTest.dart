import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../example/lib/strava_controller.dart';
import 'google_controller.dart';

//good
void main() {
  runApp(testApp());
}
//good
class testApp extends StatelessWidget{
  @override
  Widget build(BuildContext) {
    return MaterialApp(
        title: 'Googletest',
        home: homePage(),
    );
  }

}

//good
class homePage extends StatefulWidget{
  @override
  //homePage({Key key, this.title}) : super(key: key);
  //final String title;

  @override
  _homePageState createState() => _homePageState();
}

//in progress
class _homePageState extends State<homePage> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;


    });
  }

  void toRun() {
    setState(() {
      // ignore: unnecessary_statements
      GoogleController gtest = new GoogleController();
      gtest.doFirstTimeSetup();

      //get some dates and times

      gtest.updateData(DateTime(2015, 11, 11),DateTime.now());

    });
  }]

  void callCameronThing(){
    StravaController stravaController = new StravaController();
    //all we have to do here... start up strava process..
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Googletest'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('SIGN IN GOOGLE THING'),
          onPressed: toRun,
        ),
        child: ElevatedButton(
          child: Text('SIGN IN STRAVA'),
          onPressed: callCameronThing,
        ),
      ),

    );
  }

}