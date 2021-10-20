class StravaTypes {
  // static const Map<String, String> StravaToWekoBase = {
  //   'kilojoules': 'activeEnergyBurned',
  //   'average_heartrate': 'heartRate',
  //   'foot': 'distanceWalkingRunning',
  //   'moving_time': 'moveMinutes',
  //   'swim': 'swimDistance',
  //   'ride': 'bikeDistane',
  // };

  static const Map<String, String> typeConversion = {
    'EBikeRide': 'bikeDistane',
    'Handcycle': 'bikeDistane',
    'Elliptical': 'bikeDistane',
    'Ride': 'bikeDistane',
    'Velomobile': 'bikeDistane',
    'VirtualRide': 'bikeDistane',
    'Walk': 'distanceWalkingRunning',
    'Hike': 'distanceWalkingRunning',
    'Run': 'distanceWalkingRunning',
    'VirtualRun': 'distanceWalkingRunning',
    'Swim': 'swimDistance',
  };
}
