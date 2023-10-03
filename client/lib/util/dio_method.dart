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
  } on DioException catch (e) {
    print('Error during DIO request: $e');
    if (e.response != null) {
      print('에에에러러러러데데데이이이터터터ㅓ ${e.response?.data}');
      print(e.response?.headers);
      print(e.response?.requestOptions);
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print(e.requestOptions);
      print(e.message);
    }
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
    dio.options.baseUrl = dotenv.env['CLOVA_URL']!;
    dio.options.contentType = contentType;
    // dio.options.maxRedirects.isFinite;
    // dio.options.connectTimeout = Duration(seconds: 5);
    // dio.options.receiveTimeout = Duration(seconds: 3);

    dio.options.headers = {
      'X-OCR-SECRET': dotenv.env['CLOVA_KEY']!,
    };
    var response = await dio.post(url, data: data);
    print('dioPost 성공');
    return response;
  } on DioException catch (e) {
    print('Error during DIO request: $e');
    if (e.response != null) {
      print('에에에러러러러데데데이이이터터터ㅓ ${e.response?.data}');
      print(e.response?.headers);
      print(e.response?.requestOptions);
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print(e.requestOptions);
      print(e.message);
    }
    return null;
  }
}
