import 'package:keeping/util/dio_method.dart';
import 'package:provider/provider.dart';
import 'package:keeping/provider/user_info.dart';

class NotiResponse {
  final int notiId;
  final String title;
  final String content;
  final String type;
  final String createdDate;

  NotiResponse({
    required this.notiId,
    required this.title,
    required this.content,
    required this.type,
    required this.createdDate,
  });

  factory NotiResponse.fromJson(Map<String, dynamic> json) {
    return NotiResponse(
      notiId: json['notiId'],
      title: json['title'],
      content: json['content'],
      type: json['type'],
      createdDate: json['createdDate'],
    );
  }
}

Future<List<Map<String, dynamic>>> getPushNotification(context) async {
  String memberKey =
      Provider.of<UserInfoProvider>(context, listen: false).memberKey;
  String accessToken =
      Provider.of<UserInfoProvider>(context, listen: false).accessToken;
  String url = '/noti-service/api/$memberKey';

  try {
    final response = await dioGet(
      accessToken: accessToken,
      url: url,
    );
    if (response != null) {
      final dynamic resultBody = response['resultBody'];
      print(resultBody != null);
      if (resultBody != null) {
        final List<dynamic> notiResponseList = resultBody as List<dynamic>;
        return notiResponseList.cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } else {
      return [];
    }
  } catch (error) {
    print('알림 데이터 가져오기 오류: $error');
    return [];
  }
}
