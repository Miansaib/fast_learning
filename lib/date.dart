

import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

String miladiToShamsi(String miladi) {
  String result = '';
  Gregorian g1 = Gregorian(int.parse(miladi.split('-')[0]),
      int.parse(miladi.split('-')[1]), int.parse(miladi.split('-')[2]));
  Jalali j1 = g1.toJalali();
  return j1.year.toString() +
      '/' +
      j1.month.toString() +
      '/' +
      j1.day.toString();
}
String miladiToShamsiDateTimeFormat(String isoFormat,{bool? isMiladiFormat}) {
  DateTime t = DateTime.parse(isoFormat.split(' ')[0]);
    if(isMiladiFormat==true || Get.locale!.languageCode.contains('en')){
     return t.toString().split(' ')[0] +' '+ DateTime.parse(isoFormat).hour.toString()+':'+DateTime.parse(isoFormat).minute.toString()+':'+DateTime.parse(isoFormat).second.toString();
  }
  // print(t.toString().split(' ')[0] +' '+ DateTime.parse(isoFormat).hour.toString()+':'+DateTime.parse(isoFormat).minute.toString()+':'+DateTime.parse(isoFormat).second.toString());
  String result = miladiToShamsi(t.toString().split(' ')[0]);  
  result +='    '+ DateTime.parse(isoFormat).toString().split(' ')[1].split('.')[0];

  return result;
}
int diffTwoDateInDate(String isoFormat) {
  DateTime t = DateTime.parse(isoFormat.split(' ')[0]);
  //String result = miladiToShamsi(t.toString().split(' ')[0]);  
  return DateTime.now().difference(t).inDays;
}