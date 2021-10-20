import 'dart:convert';

import 'data_types/strava_types.dart';

class stravaActivityPoint {
  Map<dynamic, dynamic> body = Map();

  stravaActivityPoint(Map Body) {
    this.body = Body;
  }

  String calculateDistanceType() {
    String foundType = search('type');
    return StravaTypes.typeConversion[foundType].toString();
  }

  dynamic search(String searchCondition) {
    print("searchn");
    print(body[searchCondition]);
    print(searchCondition);
    return body[searchCondition];
  }

  void addValues(num value, String type) {
    if (body[type] == null) {
      body[type] = 0;
    }
    if (value == null) {
      value = 0;
    }
    print("addin");
    print(value);
    print(body[type]);
    print(type);
    body[type] = body[type] + value;
  }

  void avgValues(num totvalue, String type) {
    if (body[type] != null) {
      body[type] = body[type] / totvalue;
    }
  }

  bool isNull(String searchCondition) {
    if (body[searchCondition] == null || body[searchCondition] == 0) {
      return true;
    } else {
      return false;
    }
  }

  void checkNullAll() {
    for (MapEntry e in body.entries) {
      print("Key ${e.key}, Value ${e.value}");
      if (e.value == 0) {
        body[e.key] = null;
      }
    }
  }

  Map<String, String> returnMap(String id) {
    Map<String, String> returned = new Map();
    try {
      for (final key in body.keys) {
        returned[key] = body[key].toString();
      }
      returned['identifier'] = id;
    } catch (e) {
      print(e);
    }
    return returned;
  }
}
