import 'package:flutter/material.dart';
import 'package:keeping/provider/user_link.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';

Future<String> makeNewLinkCode(BuildContext context, bool isParent) async {
  String accessToken =
      Provider.of<UserInfoProvider>(context, listen: false).accessToken;
  String memberKey =
      Provider.of<UserInfoProvider>(context, listen: false).memberKey;
  String url = isParent
      ? '/member-service/auth/api/$memberKey/parent/linkcode'
      : '/member-service/auth/api/$memberKey/child/linkcode';

  // 데이터를 가져오는 로직을 추가 (예: Dio 사용)
  final response = await dioPost(accessToken: accessToken, url: url);
  print(response);
  final linkCode = response['resultBody']['linkcode'];
  Provider.of<UserLinkProvider>(context, listen: false).updateUserCode(
    myCode: linkCode,
  );
  return linkCode;
}
