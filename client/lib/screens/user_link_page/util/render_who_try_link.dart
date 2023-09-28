import 'package:flutter/material.dart';
import 'package:keeping/provider/user_link.dart';
import 'package:keeping/screens/user_link_page/util/make_new_link_code.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';

Future<String> renderWhoTryLink(BuildContext context, userCode) async {
  String accessToken =
      Provider.of<UserInfoProvider>(context, listen: false).accessToken;
  String memberKey =
      Provider.of<UserInfoProvider>(context, listen: false).memberKey;

  final response = await dioGet(
    accessToken: accessToken,
    url: '/member-service/auth/api/$memberKey/link/$userCode',
  );

  if (response != null) {
    print('$accessToken, $memberKey, $userCode');
    print(response);
    return response['resultStatus']['resultMessage'];
  } else {
    // 응답이 실패한 경우 오류 처리
    print('키키');
    return '오류 발생'; // 실제 오류 처리 결과로 대체하세요.
  }
}
