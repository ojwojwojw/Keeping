import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeping/provider/user_link.dart';
import 'package:keeping/screens/user_link_page/after_user_link_page.dart';
import 'package:keeping/util/dio_method.dart';
import 'package:keeping/util/page_transition_effects.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _baseUrl = dotenv.env['BASE_URL'];
Future<String> renderWhoTryLink(BuildContext context, userCode) async {
  String accessToken =
      Provider.of<UserInfoProvider>(context, listen: false).accessToken;
  String memberKey =
      Provider.of<UserInfoProvider>(context, listen: false).memberKey;
  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  try {
    final response = await http.get(
        Uri.parse('$_baseUrl/member-service/auth/api/$memberKey/link/$userCode'),
        headers: headers);
    print('우욱');
    Map<String, dynamic> jsonResponse =
        json.decode(utf8.decode(response.bodyBytes));
    print(jsonResponse);
    if (jsonResponse['resultStatus']['successCode'] == 0) {
      String oppName = jsonResponse['resultBody'];
      // 누군가 나에게 연결 대기중인 경우. beforePage에서 이름을 띄워준다.
    return '$oppName님이 연결 대기중입니다.';
    } else if (jsonResponse['resultStatus']['resultCode'] == "400") {
      // 내가 상대방의 연결을 대기중인 경우, afterPage로 간다.
      noEffectTransition(context, AfterUserLinkPage());
      return '나는 연결 중이야!';
    } else {
      // 아무도 연결을 안 하는 상태일 때
      return jsonResponse['resultStatus']['resultMessage'];
    }
  } catch (e) {
    print('Error occurred in renderWhoTryLink: $e');
    return '오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
  }
}

