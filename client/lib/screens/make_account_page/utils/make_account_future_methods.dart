import 'package:keeping/util/dio_method.dart';

// 계좌 개설을 위한 인증번호 요청
Future<dynamic> phoneCheck({
  required String accessToken, required int memberKey, required String phone
}) async {
  final response = await dioPost(
    accessToken: accessToken,
    url: '/bank-service/account/phone-check/$memberKey',
    data: {
      "phone": phone
    }
  );

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}

// 계좌 개설을 위한 인증번호 확인
Future<dynamic> phoneAuth({
  required String accessToken, required int memberKey, required String code
}) async {
  final response = await dioPost(
    accessToken: accessToken,
    url: '/bank-service/account/phone-auth/$memberKey',
    data: {
      "code": code
    }
  );

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}

// 계좌 개설
Future<dynamic> makeAccount({
  required String accessToken, required int memberKey, required List<String> authPassword
}) async {
  final response = await dioPost(
    accessToken: accessToken,
    url: '/bank-service/account/$memberKey',
    data: {
      "authPassword": authPassword
    }
  );

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}