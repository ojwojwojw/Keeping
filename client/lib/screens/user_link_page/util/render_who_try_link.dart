import 'package:flutter/material.dart';
import 'package:keeping/provider/user_link.dart';
import 'package:keeping/screens/user_link_page/after_user_link_page.dart';
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
    Provider.of<UserLinkProvider>(context, listen: false)
        .updateUserCode(myCode: userCode);

    print('누가 연결 시도하나요?');
    if (response['resultStatus']['successCode'] == 0) {
      return Future.value(response['resultBody'] + '님이 연결을 시도중입니다.');
    } else if (response['resultStatus']['resultCode'] == '400') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AfterUserLinkPage()),
      );
    }
  }

  print('키키');
  return Future.value(response['resultStatus']
      ['resultMessage']); // You can customize the error message.
}
