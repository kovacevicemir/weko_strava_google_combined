//import 'package:flutter_weko/api_controller/data_types.dart';
//import 'package:flutter_weko/api_controller/weko_endpoints.dart';

import 'package:google_flutter_con3/Googletesting/api_controller/weko_endpoints.dart';

import 'data_types.dart';

class UnifiedHealthData {
  Map<String, dynamic> innerData = {};
  WekoHealthDataAPI api = WekoHealthDataAPI();

  UnifiedHealthData() {
    DataTypes.WekoDataPointsBase.forEach((type) {
      innerData[type] = [];
    });
  }

  void pushToWeko(String id) {
    Map<String, String> outerData = {};

    for (int i = 0; i < DataTypes.WekoDataPointsBase.length; i++) {
      String type = DataTypes.WekoDataPointsBase[i];
      var point = innerData[type];

      if (point.length == 0) {
        continue;
      }

      num sum = 0;
      num max = 0;
      num min = point.last;
      point.forEach((e) {
        sum += e;
        max = max > e ? max : e;
        min = min < e ? min : e;
      });

      var operation = DataTypes.combinationMap[type]!;
      if (operation.contains(Combine.SUM)) {
        outerData[type] = '$sum';
      }
      if (operation.contains(Combine.LATEST)) {
        outerData['${type}Latest'] = '${point.last}';
      }
      if (operation.contains(Combine.AVERAGE)) {
        outerData['${type}Avg'] = '${sum / point.length}';
      }
      if (operation.contains(Combine.HIGH)) {
        outerData['${type}High'] = '$max';
      }
      if (operation.contains(Combine.LOW)) {
        outerData['${type}Low'] = '$min';
      }
    }

    outerData['identifier'] = id;
    WekoHealthDataAPI.update(outerData);
  }
}
