import 'package:flutter/material.dart';
import 'package:keeping/provider/user_link.dart';
import 'package:keeping/screens/user_link_page/util/make_new_link_code.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';

Future<String> renderMyNumber(BuildContext context, bool isParent) async {
  String accessToken =
      Provider.of<UserInfoProvider>(context, listen: false).accessToken;
  String memberKey =
      Provider.of<UserInfoProvider>(context, listen: false).memberKey;
  String url = isParent
      ? '/member-service/auth/api/$memberKey/parent/linkcode'
      : '/member-service/auth/api/$memberKey/child/linkcode';

  final response = await dioGet(accessToken: accessToken, url: url);
  print(response);
  print('여기');
  if (response != null && response['resultBody'] != null) {
    final linkCode = response['resultBody']['linkcode'];
    final expire = response['resultBody']['expire'];
    Provider.of<UserLinkProvider>(context, listen: false).updateUserCode(
      myCode: linkCode,
    );
    Provider.of<UserLinkProvider>(context, listen: false).updateUserCode(
      expire: expire,
    );
    return linkCode.toString();
  } else {
    // 오류가 발생한 경우 또는 데이터가 없는 경우 처리
    return await makeNewLinkCode(
      context,
      isParent,
    ); // makeNewLinkCode를 await으로 호출
  }
}
