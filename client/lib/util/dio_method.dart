import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<dynamic> dioPost({
  String? accessToken,
  required String url,
  String contentType = 'application/json',
  dynamic data,
}) async {
  var dio = Dio();
  try {
    dio.options.baseUrl = dotenv.env['BASE_URL']!;
    dio.options.contentType = contentType;
    // dio.options.maxRedirects.isFinite;
    // dio.options.connectTimeout = Duration(seconds: 5);
    // dio.options.receiveTimeout = Duration(seconds: 3);

    dio.options.headers = {
      'Authorization': 'Bearer $accessToken',
    };
    var response = await dio.post(url, data: data);
    print('dioPost 성공');
    return response.data;
  } catch (e) {
    print('Error during DIO request: $e');
    return null;
  }
}

Future<dynamic> dioGet({String? accessToken, required String url}) async {
  var dio = Dio();

  try {
    dio.options.baseUrl = dotenv.env['BASE_URL']!;
    // dio.options.maxRedirects.isFinite;
    // dio.options.connectTimeout = Duration(seconds: 5);
    // dio.options.receiveTimeout = Duration(seconds: 3);

    dio.options.headers = {
      'Authorization': 'Bearer $accessToken',
    };
    var response = await dio.get(url);
    print('dioGet 성공');
    return response.data;
  } catch (e) {
    print('Error during DIO request: $e');
    return null;
  }
}

Future<dynamic> dioPostForCLOVA({
  required String url,
  String contentType = 'application/json',
  dynamic data,
}) async {
  var dio = Dio();
  try {
    dio.options.baseUrl = 'https://pjz2waj74v.apigw.ntruss.com/custom/v1/25090/f0d9e8175108a40aa63f310f3e37669b8de04e970078648956ebe38c1ffd7285';
    dio.options.contentType = contentType;
    // dio.options.maxRedirects.isFinite;
    // dio.options.connectTimeout = Duration(seconds: 5);
    // dio.options.receiveTimeout = Duration(seconds: 3);

    dio.options.headers = {
      'X-OCR-SECRET': 'QnlFZlFOR21SanpIVElRU0FFc2RaZmZlbXRhTnRrSW0=',
    };
    var response = await dio.post(url, data: data);
    print('dioPost 성공');
    return response;
  } catch (e) {
    print('Error during DIO request: $e');
    return null;
  }
}

// Future<dynamic> dioPostForCLOVA({
//   required String url,
//   String contentType = 'multipart/form-data',
//   dynamic data,
// }) async {
//   var dio = Dio();
//   try {
//     dio.options.baseUrl = 'https://pjz2waj74v.apigw.ntruss.com/custom/v1/25090/f0d9e8175108a40aa63f310f3e37669b8de04e970078648956ebe38c1ffd7285';
//     dio.options.contentType = contentType;
//     // dio.options.maxRedirects.isFinite;
//     // dio.options.connectTimeout = Duration(seconds: 5);
//     // dio.options.receiveTimeout = Duration(seconds: 3);

//     dio.options.headers = {
//       'X-OCR-SECRET': 'QnlFZlFOR21SanpIVElRU0FFc2RaZmZlbXRhTnRrSW0=',
//     };
//     var response = await dio.post(url, data: data);
//     print('dioPost 성공');
//     return response.data;
//   } catch (e) {
//     print('Error during DIO request: $e');
//     return null;
//   }
// }

