
// 로그인 완료 후 필요정보 요청
import 'package:keeping/util/dio_method.dart';

Future<dynamic> getChildrenList({
  required String? accessToken, required String? memberKey, required String? fcmToken,
}) async {
  if (accessToken != null && memberKey != null && fcmToken != null) {
    try {
      final response = await dioGet(
        accessToken: accessToken,
        url: '/member-service/auth/api/$memberKey/login-check/$fcmToken'
      );
      print('로그인 완료 후 필요정보 응답 $response');
      return response;
    } catch (e) {
      print("로그인 완료 후 필요정보 요청 에러 $e");
    }
  }
}