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
    return response;
  } catch (e) {
    print(e);
  }

  // // 이후 처리는 나중에..
  // if (response != null) {
  //   return response;
  // } else {
  //   return null;
  // }
}

// 저금통 상세 조회
Future<dynamic> getPiggyDetailList({
  required String accessToken, required String memberKey, required String piggyAccountNumber,
}) async {
  final response = await dioGet(
    accessToken: accessToken,
    url: '/bank-service/piggy/$memberKey/$piggyAccountNumber',
  );

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}

// 저금통 등록
Future<dynamic> makePiggy({
  required String accessToken, required String memberKey,
  required String content, required int goalMoney, required List<String> authPassword, String? uploadImage
}) async {
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

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}

// 저금통 저금하기
Future<dynamic> savePiggy({
  required String accessToken, required String memberKey,
  required String accountNumber, required String piggyAccountNumber, required int money, required List<String> authPassword
}) async {
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

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}