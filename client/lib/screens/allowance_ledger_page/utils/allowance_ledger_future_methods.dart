import 'package:keeping/util/dio_method.dart';

// 계좌의 상세 내역 포함한 거래 내역 조회
Future<dynamic> getAccountList(
    {required String? accessToken,
    required String? memberKey,
    required String? accountNumber,
    required String? targetKey}) async {
  if (accessToken != null &&
      memberKey != null &&
      accountNumber != null &&
      targetKey != null) {
    try {
      final response = await dioGet(
        accessToken: accessToken,
        url:
            '/bank-service/api/$memberKey/account-history/$targetKey/$accountNumber',
      );
      print('계좌의 상세 내역 포함한 거래 내역 조회 응답 $response');
      return response;
    } catch (e) {
      print('계좌의 상세 내역 포함한 거래 내역 조회 에러 $e');
    }
  } else {
    return;
  }
}

// 거래 상세 내용 입력(한 개)
Future<dynamic> createAccountDetail({
  required String? accessToken,
  required String? memberKey,
  required int? accountHistoryId,
  required String? content,
  required int? money,
  required String? smallCategory,
}) async {
  if (accessToken != null &&
      memberKey != null &&
      accountHistoryId != null &&
      content != null &&
      money != null &&
      smallCategory != null) {
    try {
      print(
          'accessToken: $accessToken, memberKey: $memberKey, accountHistoryId: $accountHistoryId, content: $content, money: $money, smallCategory: $smallCategory');
      final response = await dioPost(
          accessToken: accessToken,
          url: '/bank-service/api/$memberKey/account-detail',
          data: {
            "accountDetailList": [
              {
                "accountHistoryId": accountHistoryId,
                "content": content,
                "money": money,
                "smallCategory": smallCategory,
              }
            ]
          });
      print('거래 상세 내용 입력 응답 $response');
      return response['resultStatus']['successCode'];
    } catch (e) {
      print('거래 상세 내용 입력 에러 $e');
    }
  } else {
    print("거래 상세 내용 입력 값 안들어옴");
    return;
  }
}

// 날짜별로 거래 내역 반환
Future<dynamic> getAccountListByDate({
  required String? accessToken,
  required String? memberKey,
  required String? targetKey,
  required String? accountNumber,
  required String? date,
  String? historyType,
}) async {
  if (accessToken != null &&
      memberKey != null &&
      accountNumber != null &&
      date != null) {
    print("날짜별 거래 내역 $date");
    try {
      final response = await dioGet(
        accessToken: accessToken,
        url:
            '/bank-service/api/$memberKey/account-history/$targetKey/$accountNumber/$date${historyType == null ? '' : '/$historyType'}',
      );
      print(
          '날짜별로 거래 내역 반환 url ${'/bank-service/api/$memberKey/account-history/$targetKey/$accountNumber/$date${historyType == null ? '' : '/$historyType'}'}');
      print('날짜별로 거래 내역 반환 응답 $response');
      return response;
    } catch (e) {
      print('날짜별로 거래 내역 반환 에러 $e');
    }
  } else {
    return;
  }
}

// 계좌 정보 반환
Future<dynamic> getAccountInfo({
  required String? accessToken,
  required String? memberKey,
  required String? targetKey,
}) async {
  print('토큰: $accessToken, 멤버 키 : $memberKey, 타겟 키 : $targetKey');

  if (accessToken != null && memberKey != null && targetKey != null) {
    try {
      final response = await dioGet(
          accessToken: accessToken,
          url: '/bank-service/api/$memberKey/account/$targetKey');
      print('계좌 정보 반환 응답 $response');
      if (response['resultStatus']['resultCode'] == 404) {
        return false;
      } else {
        return response;
      }
    } catch (e) {
      print('계좌 정보 반환 에러 $e');
    }
  } else {
    return;
  }
}

// 월 지출 총액
Future<dynamic> getMonthTotalExpense({
  required String? accessToken,
  required String? memberKey,
  required String? targetKey,
  required String? date,
}) async {
  if (accessToken != null &&
      memberKey != null &&
      targetKey != null &&
      date != null) {
    try {
      print(date);
      final response = await dioGet(
          accessToken: accessToken,
          url:
              '/bank-service/api/$memberKey/account-history/$targetKey/expense/$date');
      print('월 지출 총액 응답 $response');
      return response;
    } catch (e) {
      print('월 지출 총액 에러 $e');
    }
  } else {
    return;
  }
}
