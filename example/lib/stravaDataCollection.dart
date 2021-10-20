// import 'package:flutter_weko/api_controller/Strava/stravaHealthActivity.dart';
// import 'package:flutter_weko/api_controller/data_types/strava_types.dart';
// import 'package:flutter_weko/api_controller/unified_data.dart';

// class stravaDataCollection extends UnifiedHealthData {
//   stravaDataCollection() : super();

//   void addDataList(List<HealthDataPoint> data) {
//     data.forEach((dataPoint) {
//       addData(dataPoint);
//     });
//   }

//   void addData(stravaActivityPoint data) {
//     String? dataType = StravaTypes.StravaToWekoBase[data.type];
//     innerData[dataType!].add(data.value);
//   }
// }
