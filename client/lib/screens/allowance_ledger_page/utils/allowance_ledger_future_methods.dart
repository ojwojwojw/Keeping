import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:keeping/util/dio_method.dart';

// 계좌의 상세 내역 포함한 거래 내역 조회
Future<dynamic> getAccountList({
  required String? accessToken, required String? memberKey, required String? accountNumber, required String? targetKey
}) async {
  if (accessToken != null && memberKey != null && accountNumber != null && targetKey != null) {
    // try {
      final response = await dioGet(
        accessToken: accessToken,
        url: '/bank-service/api/$memberKey/account-history/$targetKey/$accountNumber',
      );
      print('계좌의 상세 내역 포함한 거래 내역 조회 응답 $response');
      return response;
    // } catch (e) {
      // print('계좌의 상세 내역 포함한 거래 내역 조회 에러 $e');
    // }
  } else {
    return;
  }
}

// 거래 상세 내용 입력
Future<dynamic> createAccountDetail({
  required String? accessToken, required String? memberKey,
  required int? accountHistoryId, required String? content, required int? money
}) async {
  if (accessToken != null && memberKey != null && accountHistoryId != null && content != null && money != null) {
    try {
      final response = await dioPost(
        accessToken: accessToken,
        url: '/bank-service/api/$memberKey/account-detail',
        data: {
          "accountHistoryId": accountHistoryId,
          "content": content,
          "money": money
        }
      );
      print('거래 상세 내용 입력 응답 $response');
      return response['resultStatus']['successCode'];
    } catch (e) {
      print('거래 상세 내용 입력 에러 $e');
    }
  } else {
    return;
  }
}

// 날짜별로 거래 내역 반환
Future<dynamic> getAccountListByDate({
  required String? accessToken, required String? memberKey, required String? accountNumber, required String? date,
}) async {
  if (accessToken != null && memberKey != null && accountNumber != null && date != null) {
    try {
      final response = await dioGet(
        accessToken: accessToken,
        url: '/bank-service/api/$memberKey/account-history/$accountNumber/$date',
      );
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
  required String? accessToken, required String? memberKey, required String? targetKey,
}) async {
  if (accessToken != null && memberKey != null && targetKey != null) {
    try {
      final response = await dioGet(
        accessToken: accessToken,
        url: '/bank-service/api/$memberKey/account/$targetKey'
      );
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