import 'package:http/http.dart' as http;
import 'dart:convert';

// class Get {
//   final int userId;
//   final int id;
//   final String title;
//   final String body;

//   Get({
//     required this.userId,
//     required this.id,
//     required this.title,
//     required this.body,
//   });

//   factory Get.fromJson(Map<String, dynamic> json) {
//     return Get(
//       userId: json['userId'],
//       id: json['id'],
//       title: json['title'],
//       body: json['body'],
//     );
//   }
// }

Future<List<dynamic>?> axiosGet(
    String url, Map<String, String>? headers) async {
  try {
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      // var result = jsonDecode(response.body);
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
