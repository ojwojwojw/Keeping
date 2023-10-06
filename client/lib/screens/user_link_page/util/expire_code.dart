import 'package:flutter/material.dart';
import 'package:keeping/provider/user_link.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';

Future<int> expireCode(BuildContext context) async {
  String accessToken =
      Provider.of<UserInfoProvider>(context, listen: false).accessToken;
  String memberKey =
      Provider.of<UserInfoProvider>(context, listen: false).memberKey;
  bool isParent = Provider.of<UserInfoProvider>(context, listen: false).parent;
  String url = isParent
      ? '/member-service/auth/api/$memberKey/parent/linkcode'
      : '/member-service/auth/api/$memberKey/child/linkcode';

  final response = await dioGet(url: url, accessToken: accessToken);
  print(response);
  final expire = response['resultBody']['expire'];
  Provider.of<UserLinkProvider>(context, listen: false).updateUserCode(
    expire: expire,
  );
  return expire;
}

String formatSecondsToHHMMSS(int seconds) {
  final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
  final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
  final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
  return '$hours:$minutes:$remainingSeconds';
}
