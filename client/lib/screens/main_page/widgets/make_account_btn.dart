import 'package:flutter/material.dart';
import 'package:keeping/screens/make_account_page/make_account_page.dart';
import 'package:keeping/screens/user_link_page/before_user_link_page.dart';
import 'package:keeping/styles.dart';

class MakeAccountBtn extends StatelessWidget {
  MakeAccountBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => MakeAccountPage()));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: SizedBox(
          height: 160,
          child: DecoratedBox(
            decoration: roundedBoxWithShadowStyle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.add, color: Colors.grey,),
                Text(
                  ' 계좌 만들기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget disabledAccountForParent(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => BeforeUserLinkPage()));
    },
    child: Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: SizedBox(
        height: 160,
        child: DecoratedBox(
          decoration: roundedBoxWithShadowStyle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.add, color: Colors.grey,),
              Text(
                ' 자녀 연결하러 가기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 25
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget noAccountForParent(BuildContext context) {
  return InkWell(
    onTap: () {

    },
    child: Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: SizedBox(
        height: 160,
        child: DecoratedBox(
          decoration: roundedBoxWithShadowStyle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                '자녀 계좌가 없습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 25
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget disabledAccount() {
  return Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12),
    child: SizedBox(
      height: 160,
      child: DecoratedBox(
        decoration: roundedBoxWithShadowStyle(),
      ),
    ),
  );
}