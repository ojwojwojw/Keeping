import 'package:keeping/util/dio_method.dart';

// 온라인 결제 전체조회
Future<dynamic> getOnlinePaymentRequestList({
  required String? accessToken, required String? memberKey, required String? targetKey,
}) async {
  if (accessToken != null && memberKey != null && targetKey != null) {
    try {
      final response = await dioGet(
        accessToken: accessToken,
        url: '/bank-service/api/$memberKey/online/$targetKey',
      );
      print('온라인 결제 전체조회 응답 $response');
      return response;
    } catch (e) {
      print('온라인 결제 전체조회 에러 $e');
    }
  } else {
    return;
  }
}

// 필터링된 온라인 결제 전체조회
Future<dynamic> getFilteredOnlinePaymentRequestList({
  required String? accessToken, required String? memberKey, required String? targetKey, required String? status
}) async {
  if (accessToken != null && memberKey != null && targetKey != null && status != null) {
    try {
      final response = await dioGet(
        accessToken: accessToken,
        url: '/bank-service/api/$memberKey/online/$targetKey/$status',
      );
      print('필터링된 온라인 결제 전체조회 응답 $response');
      return response;
    } catch (e) {
      print('필터링된 온라인 결제 전체조회 에러 $e');
    }
  } else {
    return;
  }
}

// 온라인 결제 상세 조회
Future<dynamic> getOnlinePaymentRequestDetail({
  required String accessToken, required String memberKey, required int onlineId
}) async {
  try {
    final response = await dioGet(
      accessToken: accessToken,
      url: '/bank-service/online/parent/$memberKey/$onlineId',
    );
    print('온라인 결제 상세 조회 응답 $response');
    return response;
  } catch (e) {
    print('온라인 결제 상세 조회 에러 $e');
  }
}

// 자녀 - 온라인 결제 요구
Future<dynamic> createOnlinePaymentRequest({
  required String? accessToken, required String? memberKey,
  required String? productName, required String? url, required String? content, required int? totalMoney, required int? childMoney
}) async {
  if (accessToken != null && memberKey != null && productName != null && url != null && content != null && totalMoney != null && childMoney != null) {
    try {
      final response = await dioPost(
        accessToken: accessToken,
        url: '/bank-service/api/$memberKey/online',
        data: {
          "productName": productName,
          "url": url,
          "content": content,
          "totalMoney": totalMoney,
          "childMoney": childMoney,
        }
      );
      print('자녀 온라인 결제 요구 응답 $response');
      return response['resultStatus']['successCode'];
    } catch (e) {
      print('자녀 온라인 결제 요구 에러 $e');
    }
  } else {
    return;
  }
}

// 부모 = 온라인 결제 승인
Future<dynamic> approveOnlinePaymentRequest({
  required String? accessToken, required String? memberKey, 
  required int? onlineId, required String? childKey, String? comment,
}) async {
  if (accessToken != null && memberKey != null && onlineId != null && childKey != null) {
    try {
      final response = await dioPost(
        accessToken: accessToken,
        url: '/bank-service/api/$memberKey/online/approve',
        data: {
          "onlineId": memberKey,
          "childKey": childKey,
          "approve": comment != null ? 'REJECT' : 'APPROVE',
          "comment": comment
        }
      );
      print('부모 온라인 결제 승인 응답 $response');
      return response;
    } catch (e) {
      print('부모 온라인 결제 승인 에러 $e');
    }
  } else {
    return;
  }
}