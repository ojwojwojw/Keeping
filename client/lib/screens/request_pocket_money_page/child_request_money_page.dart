import 'package:flutter/material.dart';
import 'package:keeping/provider/request_money_provider.dart';
import 'package:keeping/screens/online_payment_request/widgets/online_payment_request_filters.dart';
import 'package:keeping/screens/request_pocket_money_page/widgets/request_money_box.dart';
import 'package:keeping/screens/request_pocket_money_page/widgets/request_money_content.dart';
import 'package:keeping/screens/request_pocket_money_page/widgets/request_money_filter.dart';
import 'package:keeping/screens/request_pocket_money_page/widgets/request_money_how_much.dart';
import 'package:keeping/widgets/bottom_btn.dart';
import 'package:keeping/widgets/header.dart';
import 'package:keeping/widgets/bottom_nav.dart';
import 'package:keeping/widgets/render_field.dart';
import 'package:provider/provider.dart';

class ChildRequestMoneyPage extends StatefulWidget {
  const ChildRequestMoneyPage({super.key});

  @override
  State<ChildRequestMoneyPage> createState() => _ChildRequestMoneyPageState();
}

class _ChildRequestMoneyPageState extends State<ChildRequestMoneyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '용돈 조르기'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // InkWell로 감싸서 클릭 가능하게 만듭니다.
            InkWell(
              onTap: () {
                print('용돈 조르기 다음 화면');
                // 클릭 시 다음 페이지로 이동합니다.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RequestPocketMoneySecondPage()),
                );
              },
              child: requestPocketMoneyBox(),
            ),
            RequestMoneyFilters(),
            Text('용돈 조르기 내역이 없습니다.')
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }

  // "전체" 탭에 대한 컨텐츠를 생성하는 함수
  Widget totalRequestPockeyMoney() {
    return Center(
      child: Text(
        '전체 요청 내역', // 원하는 내용을 여기에 추가
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // "대기중" 탭에 대한 컨텐츠를 생성하는 함수
  Widget waitingRequestPockeyMoney() {
    return Center(
      child: Text(
        '대기 중인 요청 내역', // 원하는 내용을 여기에 추가
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // "승인" 탭에 대한 컨텐츠를 생성하는 함수
  Widget acceptRequestPockeyMoney() {
    return Center(
      child: Text(
        '승인된 요청 내역', // 원하는 내용을 여기에 추가
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // "거부" 탭에 대한 컨텐츠를 생성하는 함수
  Widget denyRequestPockeyMoney() {
    return Center(
      child: Text(
        '거부된 요청 내역', // 원하는 내용을 여기에 추가
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RequestPocketMoneySecondPage extends StatefulWidget {
  @override
  _RequestPocketMoneySecondPageState createState() =>
      _RequestPocketMoneySecondPageState();
}

class _RequestPocketMoneySecondPageState
    extends State<RequestPocketMoneySecondPage> {
  bool _isButtonDisabled = true;
  String _money = ''; // 초기값은 빈 문자열로 설정
  String _content = ''; // 초기값은 빈 문자열로 설정
  @override
  void initState() {
    super.initState();
    _updateButtonDisabledState(); // 버튼 비활성화 상태 초기화
  }

  // _isAccepted 값을 업데이트하는 메서드
  void _updateButtonDisabledState() {
    setState(() {
      if (_money != '' && _content != '') {
        _isButtonDisabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(text: '용돈 조르기'),
      body: Center(
        child: Column(
          children: [
            requestMoneyHowMuch(context),
            requestMoneyContent(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomBtn(
        text: '조르기 요청하기',
        action: () {
          _money =
              Provider.of<RequestMoneyProvider>(context, listen: false).money;
          _content =
              Provider.of<RequestMoneyProvider>(context, listen: false).content;
          // 버튼을 누를 때 _money와 _content 값을 출력합니다.
          print('Money: $_money');
          print('Content: $_content');

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RequestPocketMoneyThirdPage()),
          );
        },
        isDisabled: _isButtonDisabled,
      ),
    );
  }

  Widget requestMoneyHowMuch(BuildContext context) {
    TextEditingController _money = TextEditingController();

    void handleRequestMoney(dynamic value) {
      if (value is String) {
        Provider.of<RequestMoneyProvider>(context, listen: false)
            .updateRequestMoney(money: value);
        print('용돈 수정 중: $value');
      } else {
        Provider.of<RequestMoneyProvider>(context, listen: false)
            .updateRequestMoney(money: value);
      }
      _updateButtonDisabledState();
    }

    return Container(
      child: Column(
        children: [
          Builder(
            builder: (BuildContext context) {
              // Builder를 사용하여 새로운 빌드 컨텍스트를 얻습니다.
              return renderTextFormField(
                label: '얼마를 조를까요?',
                controller: _money,
                onChange: handleRequestMoney,
                isNumber: true,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget requestMoneyContent(BuildContext context) {
    TextEditingController _content = TextEditingController();

    void handleRequestMoneyContent(dynamic value) {
      if (value is String) {
        Provider.of<RequestMoneyProvider>(context, listen: false)
            .updateRequestMoney(content: value, isContent: true);
        print('하고 싶은 말 수정 중: $value');
      } else {
        Provider.of<RequestMoneyProvider>(context, listen: false)
            .updateRequestMoney(isContent: false, content: value);
      }
      _updateButtonDisabledState;
    }

    return Container(
      child: Column(
        children: [
          // Text('얼마를 조를까요?'),
          Builder(
            builder: (BuildContext context) {
              // Builder를 사용하여 새로운 빌드 컨텍스트를 얻습니다.
              return renderBoxFormField(
                label: '하고 싶은 말을 적어보세요!',
                controller: _content,
                onChange: handleRequestMoneyContent,
              );
            },
          ),
        ],
      ),
    );
  }
}

class RequestPocketMoneyThirdPage extends StatefulWidget {
  @override
  _RequestPocketMoneyThirdPageState createState() =>
      _RequestPocketMoneyThirdPageState();
}

class _RequestPocketMoneyThirdPageState
    extends State<RequestPocketMoneyThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyHeader(text: '용돈 조르기'),
      body: Center(
        child: Text('엄마에게 \n 용돈 조르기 완료!'),
      ),
    );
  }
}
