import 'package:keeping/util/dio_method.dart';

// 자녀 - 온라인 결제 전체조회
Future<dynamic> getOnlinePaymentRequestListForChild({
  required String accessToken, required String memberKey
}) async {
  final response = await dioGet(
    accessToken: accessToken,
    url: '/bank-service/online/$memberKey',
  );

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}

// 자녀 - 필터링된 온라인 결제 전체조회
Future<dynamic> getFilteredOnlinePaymentRequestListForChild({
  required String accessToken, required String memberKey, required String childKey, required String status
}) async {
  final response = await dioGet(
    accessToken: accessToken,
    url: '/bank-service/online/$memberKey/$childKey/$status',
  );

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}

// 부모 - 온라인 결제 전체조회
Future<dynamic> getOnlinePaymentRequestListForParent({
  required String accessToken, required String memberKey, required String childKey
}) async {
  final response = await dioGet(
    accessToken: accessToken,
    url: '/bank-service/online/parent/$memberKey/$childKey',
  );

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}

// 부모 - 필터링된 온라인 결제 전체조회
Future<dynamic> getFilteredOnlinePaymentRequestListForParent({
  required String accessToken, required String memberKey, required String childKey, required String status
}) async {
  final response = await dioGet(
    accessToken: accessToken,
    url: '/bank-service/online/parent/$memberKey/$childKey/$status',
  );

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}

// 온라인 결제 상세 조회
Future<dynamic> getOnlinePaymentRequestDetail({
  required String accessToken, required String memberKey, required int onlineId
}) async {
  final response = await dioGet(
    accessToken: accessToken,
    url: '/bank-service/online/parent/$memberKey/$onlineId',
  );

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}

// 자녀 - 온라인 결제 요구
Future<dynamic> createOnlinePaymentRequest({
  required String accessToken,
  required String memberKey, required String name, required String url, required String reason, required int cost, required int paidMoney
}) async {
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

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}

// 부모 = 온라인 결제 승인
Future<dynamic> approveOnlinePaymentRequest({
  required String accessToken,
  required String memberKey, required String childKey, String? message,
}) async {
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

  // 이후 처리는 나중에..
  if (response != null) {
    return response;
  } else {
    return null;
  }
}