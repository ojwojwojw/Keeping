import 'package:flutter/material.dart';

class OcrProvider with ChangeNotifier {
  List<String>? textList;

  void saveTextData(List<String>? lst) {
    this.textList = lst;
    notifyListeners();
  }
}
