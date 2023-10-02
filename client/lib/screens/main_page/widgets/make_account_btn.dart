import 'package:flutter/material.dart';
import 'package:keeping/screens/make_account_page/make_account_page.dart';
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
        padding: const EdgeInsets.symmetric(vertical: 24),
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
                  '계좌 만들기',
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