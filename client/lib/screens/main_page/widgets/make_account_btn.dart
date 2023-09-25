import 'package:flutter/material.dart';
import 'package:keeping/screens/make_account_page/make_account_page.dart';

class MakeAccountBtn extends StatelessWidget {
  MakeAccountBtn({
    super.key,
    this.makeAccount
  });
  final makeAccount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        makeAccount();
        // Navigator.push(context, MaterialPageRoute(builder: (_) => MakeAccountPage()));
      },
      child: SizedBox(
        width: 350,
        height: 200,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
          ),
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
    );
  }
}