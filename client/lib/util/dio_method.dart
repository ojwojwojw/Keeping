import 'package:dio/dio.dart';

Future<dynamic> patchPiggyImage(String accessToken, dynamic baseUri, dynamic data) async {
  print("프로필 사진 서버에 업로드");
  var dio = Dio();
  try {
    dio.options.baseUrl = baseUri;
    dio.options.contentType = 'multipart/form-data';
    dio.options.maxRedirects.isFinite;
    dio.options.connectTimeout = Duration(seconds: 5);
    dio.options.receiveTimeout = Duration(seconds: 3);

    dio.options.headers = {
      'Authorization': 'Bearer $accessToken',
    };
    var response = await dio.post(
      '/bank-service/piggy/yoonyeji',
      data: data
    );
    print('업로드 성공');
    return response.data;
  } catch (e) {
    print('Error during HTTP request: $e');
  }
}