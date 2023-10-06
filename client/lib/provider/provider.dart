//전역 state를 관리하는 , 실제적으로 provider디렉토리에서 관리되어야할 dart 파일//

import 'package:flutter/material.dart';

//카운터 예제
class Counts with ChangeNotifier {
  int _count = 0; //앱 내에서 공유할 상태변수
  int get count => _count; //해당 변수를 외부에서 접근할 수 있도록 getter도 생성

  void add() {
    _count++;
    notifyListeners();
  }

  void remove() {
    _count--;
    notifyListeners();
  }
}

//어레이도 한번 테스트 해보기위한 용도//
class TestArray with ChangeNotifier {
  List<dynamic> _testArray = []; //앱 내에서 공유할 상태변수
  List<dynamic> get testArray => _testArray; //해당 변수를 외부에서 접근할 수 있도록 getter도 생성

  void addToTestArray(dynamic item) {
    _testArray.add(item);
    notifyListeners();
  }

  void removeFromTestArray(dynamic item) {
    _testArray.remove(item);
    notifyListeners();
  }
}
