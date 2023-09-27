import 'package:keeping/util/dio_method.dart';

// 저금통 전체 조회
Future<dynamic> getPiggyList({
  required String accessToken, required String memberKey,
}) async {
  try {
    final response = await dioGet(
      accessToken: accessToken,
      url: '/bank-service/piggy/$memberKey',
    );
    print('저금통 전체 조회 응답 $response');
    return response;
  } catch (e) {
    print('저금통 전체 조회 에러 $e');
  }
}

// 저금통 상세 조회
Future<dynamic> getPiggyDetailList({
  required String accessToken, required String memberKey, required String piggyAccountNumber,
}) async {
  try {
    final response = await dioGet(
      accessToken: accessToken,
      url: '/bank-service/piggy/$memberKey/$piggyAccountNumber',
    );
    print('저금통 상세 조회 응답 $response');
    return response;
  } catch (e) {
    print('저금통 상세 조회 에러 $e');
  }
}

// 저금통 등록
Future<dynamic> makePiggy({
  required String accessToken, required String memberKey,
  required String content, required int goalMoney, required List<String> authPassword, String? uploadImage
}) async {
  try {
    final response = await dioPost(
      accessToken: accessToken,
      url: '/bank-service/piggy/$memberKey',
      data: {
        "content": content,
        "goalMoney": goalMoney,
        "authPassword": authPassword,
        "uploadImage": uploadImage
      }
    );
    print('저금통 등록 응답 $response');
    return response;
  } catch (e) {
    print('저금통 등록 에러 $e');
  }
}

// 저금통 저금하기
Future<dynamic> savePiggy({
  required String accessToken, required String memberKey,
  required String accountNumber, required String piggyAccountNumber, required int money, required List<String> authPassword
}) async {
  try {
    final response = await dioPost(
      accessToken: accessToken,
      url: '/bank-service/piggy/saving/$memberKey',
      data: {
        "accountNumber": accountNumber,
        "piggyAccountNumber": piggyAccountNumber,
        "money": money,
        "authPassword": authPassword,
      }
    );
    print('저금통 저금하기 응답 $response');
    return response;
  } catch (e) {
    print('저금통 저금하기 에러 $e');
  }
}