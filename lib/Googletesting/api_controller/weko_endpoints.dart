import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class WekoHealthDataAPI {
  static const String _url =
      'https://i43bvzq8df.execute-api.ap-southeast-2.amazonaws.com/dev/healthData';
  static const Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<http.Response> _postAction(String body) async {
    var response;
    int statusCode = 0;
    int retry = 10;
    while (statusCode != 200 && retry > 0) {
      response = await http.post(
        Uri.parse(_url),
        body: body,
        headers: headers,
      );
      retry -= 1;
    }

    print('HTTP Response: ${jsonDecode(response.body)}');

    return response;
  }

  static Future post(String action, Map<String, String> payload) async {
    String body = jsonEncode({
      'action': action,
      'payload': payload,
    });

    return await _postAction(body);
  }

  static Future<void> createIfNotExists(String id) async {
    Map<String, String> payload = {'identifier': id};
    bool createEntry = false;
    await post('get', payload).then((var response) {
      createEntry = response.body == '[null]';
      if (createEntry) {
        post('create', payload);
      }
    });
  }

  static Future<void> update(Map<String, String> payload) async {
    String id = payload['identifier']!;
    createIfNotExists(id).then((void v) {
      post('update', payload);
    });
  }
}
