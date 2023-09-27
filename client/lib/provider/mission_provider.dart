import 'package:flutter/material.dart';

class MissionInfoProvider with ChangeNotifier {
  //미션 랜더링 관련
  List<Map<String, dynamic>> _missionArray = [];
  //미션 생성관련
  String _type = "";
  String _to = "";
  String _todo = "";
  String _money = "";
  String _cheeringMessage = "";
  String _startDate = "";
  String _endDate = "";

  List<Map<String, dynamic>> get missionArray => _missionArray;
  //미션 생성관련
  String get type => _type;
  String get to => _to;
  String get todo => _todo;
  String get money => _money;
  String get cheeringMessage => _cheeringMessage;
  String get startDate => _startDate;
  String get endDate => _endDate;

  void fetchData(List<Map<String, dynamic>> item) {
    _missionArray = item;
    notifyListeners();
  }

  //미션을 생성하기 위한 첫번째 페이지
  void saveTodoData({String? todo, String? endDate}) {
    if (todo != null) {
      print(todo);
      _todo = todo;
    }
    if (endDate != null) {
      _endDate = endDate;
    }
    notifyListeners();
  }
}
