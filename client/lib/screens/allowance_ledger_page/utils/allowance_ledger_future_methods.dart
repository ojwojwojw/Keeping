import 'package:keeping/util/dio_method.dart';

// 계좌의 상세 내역 포함한 거래 내역 조회
Future<dynamic> getAccountList({
  required String accessToken, required int memberKey, required String accountNumber
}) async {
  final response = await dioGet(
    accessToken: accessToken,
    url: '/bank-service/account-history/$memberKey/$accountNumber',
  );

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}

// 거래 상세 내용 입력
Future<dynamic> createAccountDetail({
  required String accessToken, required int memberKey,
  required int accountHistoryId, required String content, required int money
}) async {
  final response = await dioPost(
    accessToken: accessToken,
    url: '/bank-service/account-detail/$memberKey',
    data: {
      "accountHistoryId": accountHistoryId,
      "content": content,
      "money": money
    }
  );

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}

// 날짜별로 거래 내역 반환
Future<dynamic> getAccountListByDate({
  required String accessToken, required int memberKey, required String accountNumber, required String date,
}) async {
  final response = await dioGet(
    accessToken: accessToken,
    url: '/bank-service/account-history/$memberKey/$accountNumber/$date',
  );

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}