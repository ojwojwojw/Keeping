import 'package:flutter/material.dart';
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

  // 데이터를 가져오는 로직을 추가 (예: Dio 사용)
  final response = await dioGet(accessToken: accessToken, url: url);
  print(response);
  final linkCode = response['resultBody']['linkcode'];
  final expire = response['resultBody']['expire'];
  if (response != null && expire > 60 && linkCode != null) {
    print(linkCode);
    return linkCode;
  } else {
    // 남은 시간이 1분 이내인 경우 코드 갱신
    return makeNewLinkCode(context, isParent);
  }
}
