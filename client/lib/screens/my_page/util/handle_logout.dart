import 'package:dio/dio.dart';

Dio dio = Dio();
void handlelogout() async {
  print('로그아웃');
  final memberKey = '123456';
  try {
    var response = await dio.get('/member-service/logout/$memberKey');
    print(response);
  } catch (err) {
    print(err);
  }
}
