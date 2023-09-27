import 'package:dio/dio.dart';
import 'package:keeping/util/dio_method.dart';

// 저금통 전체 조회
Future<dynamic> getPiggyList({
  required String? accessToken, required String? memberKey, required String? targetKey,
}) async {
  if (accessToken != null && memberKey != null) {
    try {
      final response = await dioGet(
        accessToken: accessToken,
        url: '/bank-service/api/$memberKey/piggy/$targetKey',
      );
      print('저금통 전체 조회 응답 $response');
      return response;
    } catch (e) {
      print('저금통 전체 조회 에러 $e');
    }
  } else {
    return;
  }
}

// 저금통 상세 조회
Future<dynamic> getPiggyDetailList({
  required String? accessToken, required String? memberKey, required String? targetKey, required int? piggyId,
}) async {
  if (accessToken != null && memberKey != null && targetKey != null && piggyId != null) {
    try {
      final response = await dioGet(
        accessToken: accessToken,
        url: '/bank-service/api/$memberKey/piggy-history/$targetKey/$piggyId',
      );
      print('저금통 상세 조회 응답 $response');
      return response;
    } catch (e) {
      print('저금통 상세 조회 에러 $e');
    }
  } else {
    return;
  }
}

// 저금통 등록
Future<dynamic> makePiggy({
  required String? accessToken, required String? memberKey,
  required String? content, required int? goalMoney, required String? uploadImage
}) async {
  if (accessToken != null && memberKey != null && content != null && goalMoney != null && uploadImage != null) {
    try {
      final uploadImageFile = await MultipartFile.fromFile(uploadImage);
      final response = await dioPost(
        accessToken: accessToken,
        url: '/bank-service/api/$memberKey/piggy',
        contentType: 'multipart/form-data',
        data: FormData.fromMap({
          "content": content,
          "goalMoney": goalMoney,
          "uploadImage": uploadImageFile
        })
      );
      print('저금통 등록 응답 $response');
      return response['resultStatus']['successCode'];
    } catch (e) {
      print('저금통 등록 에러 $e');
    }
  } else {
    return;
  }
}

// 저금통 저금하기
Future<dynamic> savePiggy({
  required String? accessToken, required String? memberKey,
  required String? accountNumber, required String? piggyAccountNumber, required int? money, required String? authPassword
}) async {
  if (accessToken != null && memberKey != null && accountNumber != null && piggyAccountNumber != null && money != null && authPassword != null) {
    try {
      final response = await dioPost(
        accessToken: accessToken,
        url: '/bank-service/api/$memberKey/piggy/saving',
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
  } else {
    return;
  }
}