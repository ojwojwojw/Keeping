import 'package:flutter/material.dart';
import 'package:keeping/util/axios.dart';

//https://jsonplaceholder.typicode.com/posts

class AxiosTest extends StatefulWidget {
  const AxiosTest({Key? key});

  @override
  State<AxiosTest> createState() => _AxiosTestState();
}

class _AxiosTestState extends State<AxiosTest> {
  String result = ''; // 결과를 저장할 상태 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 300,
          ),
          ElevatedButton(
            onPressed: () async {
              final response = await axiosGet(
                  'https://jsonplaceholder.typicode.com/posts', null);
              if (response != null) {
                setState(() {
                  result = response.toString(); // 결과를 상태 변수에 저장
                });
              } else {
                setState(() {
                  result = 'Request failed'; // 실패 시 메시지 저장
                });
              }
            },
            child: Text('요청보내기'), // 상태 변수를 사용하여 Text 위젯 업데이트
          ),
          Text(result)
        ],
      ),
    );
  }
}
