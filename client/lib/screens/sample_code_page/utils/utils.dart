import 'dart:convert';

import 'package:http/http.dart' as http;

Future<dynamic> httpPost(String url, Map<String, String>? headers, Map<String, dynamic> body) async {
  try {
    var response = await http.post
      (Uri.parse(url), headers: headers, body: json.encode(body)
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    } else {
      print('HTTP Request Failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error during HTTP request: $e');
    return null;
  }
}