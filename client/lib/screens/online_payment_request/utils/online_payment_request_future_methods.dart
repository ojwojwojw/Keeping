import 'package:keeping/util/dio_method.dart';

// 자녀 - 온라인 결제 전체조회
Future<dynamic> getOnlinePaymentRequestListForChild({
  required String accessToken, required String memberKey
}) async {
  try {
    final response = await dioGet(
      accessToken: accessToken,
      url: '/bank-service/online/$memberKey',
    );
    print('자녀 온라인 결제 전체조회 응답 $response');
    return response;
  } catch (e) {
    print('자녀 온라인 결제 전체조회 에러 $e');
  }
}

// 자녀 - 필터링된 온라인 결제 전체조회
Future<dynamic> getFilteredOnlinePaymentRequestListForChild({
  required String accessToken, required String memberKey, required String childKey, required String status
}) async {
  try {
    final response = await dioGet(
      accessToken: accessToken,
      url: '/bank-service/online/$memberKey/$childKey/$status',
    );
    print('자녀 필터링된 온라인 결제 전체조회 응답 $response');
    return response;
  } catch (e) {
    print('자녀 필터링된 온라인 결제 전체조회 에러 $e');
  }
}

// 부모 - 온라인 결제 전체조회
Future<dynamic> getOnlinePaymentRequestListForParent({
  required String accessToken, required String memberKey, required String childKey
}) async {
  try {
    final response = await dioGet(
      accessToken: accessToken,
      url: '/bank-service/online/parent/$memberKey/$childKey',
    );
    print('부모 온라인 결제 전체조회 응답 $response');
    return response;
  } catch (e) {
    print('부모 온라인 결제 전체조회 에러 $e');
  }
}

// 부모 - 필터링된 온라인 결제 전체조회
Future<dynamic> getFilteredOnlinePaymentRequestListForParent({
  required String accessToken, required String memberKey, required String childKey, required String status
}) async {
  try {
    final response = await dioGet(
      accessToken: accessToken,
      url: '/bank-service/online/parent/$memberKey/$childKey/$status',
    );
    print('부모 필터링된 온라인 결제 전체조회 응답 $response');
    return response;
  } catch (e) {
    print('부모 필터링된 온라인 결제 전체조회 에러 $e');
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
  required String accessToken,
  required String memberKey, required String name, required String url, required String reason, required int cost, required int paidMoney
}) async {
  try {
    final response = await dioPost(
      accessToken: accessToken,
      url: '/bank-service/online',
      data: {
        "memberKey": memberKey,
        "name": name,
        "url": url,
        "reason": reason,
        "cost": cost,
        "paidMoney": paidMoney,
        "status": "YET"
      }
    );
    print('자녀 온라인 결제 요구 응답 $response');
    return response;
  } catch (e) {
    print('자녀 온라인 결제 요구 에러 $e');
  }
}

// 부모 = 온라인 결제 승인
Future<dynamic> approveOnlinePaymentRequest({
  required String accessToken,
  required String memberKey, required String childKey, String? message,
}) async {
  try {
    final response = await dioPost(
      accessToken: accessToken,
      url: '/bank-service/online/approve',
      data: {
        "memberKey": memberKey,
        "childKey": childKey,
        "status": message != null ? 'REJECT' : 'ACCEPT',
        "message": message
      }
    );
    print('부모 온라인 결제 승인 응답 $response');
    return response;
  } catch (e) {
    print('부모 온라인 결제 승인 에러 $e');
  }
}