import 'package:flutter/material.dart';

class AccountInfo extends StatelessWidget {
  AccountInfo({
    super.key,
    this.deleteAccount
  });

  final deleteAccount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        deleteAccount();
      },
      child: SizedBox(
        width: 350,
        height: 200,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  // Image(image: image),
                  Icon(Icons.money_rounded, size: 70,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '50,000원',
                        style: TextStyle(
                          fontSize: 30
                        ),
                      ),
                      Text('8월 총 지출액: 120,000원')
                    ],
                  )
                ],
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFC286FF)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(fontSize: 18)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // 테두리 둥글기 반지름 설정
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(300.0, 50.0), // 버튼의 최소 높이와 너비 설정
                  ),
                ),
                child: Text('용돈 조르기'),
              )
            ],
          ),
        ),
      ),
    );
  }
}