import 'package:intl/intl.dart';

String formattedMoney(dynamic money) => NumberFormat('#,##0원').format(money);
String formattedTime(DateTime date) => DateFormat('HH:mm').format(date);
String formattedYMDDate(DateTime date) => DateFormat('yyyy년 M월 d일').format(date);
String formattedMDDate(DateTime date) => DateFormat('M월 d일').format(date);
String formattedFullDate(DateTime date) => DateFormat('yyyy.MM.dd HH:mm').format(date);