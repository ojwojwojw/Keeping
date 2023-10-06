import 'package:keeping/util/dio_method.dart';

// 계좌 개설을 위한 인증번호 요청
Future<dynamic> phoneCheck({
  required String accessToken, required String memberKey, required String phone
}) async {
  try {
    final response = await dioPost(
      accessToken: accessToken,
      url: '/bank-service/api/$memberKey/account/phone-check',
      data: {
        "phone": phone
      }
    );
    print('계좌 개설을 위한 인증번호 요청 응답 $response');
    return response;
  } catch (e) {
    print('계좌 개설을 위한 인증번호 요청 에러 $e');
  }
}

// 계좌 개설을 위한 인증번호 확인
Future<dynamic> phoneAuth({
  required String accessToken, required String memberKey, required String code
}) async {
  try {
    final response = await dioPost(
      accessToken: accessToken,
      url: '/bank-service/api/$memberKey/account/phone-auth',
      data: {
        "code": code
      }
    );
    print('계좌 개설을 위한 인증번호 확인 응답 $response');
    return response;
  } catch (e) {
    print('계좌 개설을 위한 인증번호 확인 에러 $e');
  }
}

// 계좌 개설
Future<dynamic> makeAccount({
  required String accessToken, required String memberKey, required String authPassword
  // required String accessToken, required String memberKey, required List<String> authPassword
}) async {
  try {
    final response = await dioPost(
      accessToken: accessToken,
      url: '/bank-service/api/$memberKey/account',
      data: {
        "authPassword": authPassword
      }
    );
    print('계좌 개설 응답 $response ${response['resultStatus']['successCode'].runtimeType}');
    return response;
  } catch (e) {
    print('계좌 개설 에러 $e');
  }
}