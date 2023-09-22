import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<dynamic> dioPost({
  required String accessToken, required String url, String contentType = 'application/json', required dynamic data
}) async {
  var dio = Dio();
  try {
    dio.options.baseUrl = dotenv.env['BASE_URL']!;
    dio.options.contentType = contentType;
    dio.options.maxRedirects.isFinite;
    dio.options.connectTimeout = Duration(seconds: 5);
    dio.options.receiveTimeout = Duration(seconds: 3);

    dio.options.headers = {
      'Authorization': 'Bearer $accessToken',
    };
    var response = await dio.post(
      url,
      data: data
    );
    print('dioPost 성공');
    return response.data;
  } catch (e) {
    print('Error during DIO request: $e');
    return null;
  }
}

Future<dynamic> dioGet({
  required String accessToken, required String url
}) async {
  var dio = Dio();
  try {
    dio.options.baseUrl = dotenv.env['BASE_URL']!;
    dio.options.maxRedirects.isFinite;
    dio.options.connectTimeout = Duration(seconds: 5);
    dio.options.receiveTimeout = Duration(seconds: 3);

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