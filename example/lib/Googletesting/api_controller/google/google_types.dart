
class GoogleTypes {
  //const String device = "";

  static const derivedValues = [
    'derived:com.google.height:com.google.android.gms:merge_height',  //height
    'derived:com.google.weight:com.google.android.gms:merge_weight', //weight
    'derived:com.google.step_count.delta:com.google.android.gms:merge_step_deltas', //steps delta
    'derived:com.google.blood_pressure:com.google.android.gms:merged', //blood pressure
    'derived:com.google.heart_rate.bpm:com.google.android.gms:merge_heart_rate_bpm', //heart rate
    'derived:com.google.body.temperature:com.google.android.gms:merged', //body temperature
    'derived:com.google.oxygen_saturation:com.google.android.gms:merged' //blood oxygen
  ];

  static const Map<String?, String> googleToWekoBase = {
  'derived:com.google.height:com.google.android.gms:merge_height': 'height',  //height
  'derived:com.google.weight:com.google.android.gms:merge_weight':'wieght', //weight
  'derived:com.google.step_count.delta:com.google.android.gms:merge_step_deltas':'steps', //steps delta
  'derived:com.google.blood_pressure:com.google.android.gms:merged': 'blood_pressure',//blood pressure
  'derived:com.google.heart_rate.bpm:com.google.android.gms:merge_heart_rate_bpm': 'heart_rate', //heart rate
  //'derived:com.google.body.temperature:com.google.android.gms:merged', //body temperature
  //'derived:com.google.oxygen_saturation:com.google.android.gms:merged' //blood oxygen
  //
    };



  static const Map<String, String> GoogleHealthRequests = {
  'activeEnergyBurned':'',
  'basalEnergyBurned':'',
  'bloodGlucose':'',
  'bloodOxygen':'',
  'bloodPressureDiastolic':'',
  'bloodPressureSystolic':'',
  'bodyFatPercentage':'',
  'bodyMassIndex':'',
  'bodyTemperature':'',
  'electrodermalActivity':'',
  'heartRate':'',
  'height': 'derived:com.google.height:com.google.android.gms:merge_height',
  'restingHeartRate':'',
  'steps':'derived:com.google.step_count.delta:com.google.android.gms:merge_step_deltas',
  'waistCircumference':'',
  'walkingHeartRate':'',
  'weight':'derived:com.google.weight:com.google.android.gms:merge_weight',
  'distanceWalkingRunning':'',
  'flightsClimbed':'',
  'moveMinutes':'',
  'distanceDelta':'',
  'mindfulness':'',
  'sleepInBed':'',
  'sleepAsleep':'',
  'sleepAwake':'',
  'water':'',
  'highHeartRateEvent':'',
  'lowHeartRateEvent':'',
  'irregularHeartRateEvent':'',
  'heartRateVariabilitySDNN':'',
  'swimDistance':'',
  'bikeDistance':''

};

  static const List<String> googleTypes = [
    ];


//
//   static Map <String, String> googleToWekoBase {
//
//   };
}