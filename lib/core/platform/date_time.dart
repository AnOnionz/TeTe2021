import 'package:intl/intl.dart';


abstract class MyDateTime{
  static DateTime get day => DateTime.now();
  static String get today => DateFormat.yMd().format(DateTime.now()).replaceAll("/", "0");
//  static Future<int> get ntpTime async {
//    DateTime _day;
//    try{
//      _day = await NTP.now();
//      sl<SharedPreferences>().setString(TODAY, _day.millisecondsSinceEpoch.toString());
//      today = DateFormat.yMd().format(_day).replaceAll("/", "0");
//      day = _day;
//    }catch(e){
//      final todayStr = sl<SharedPreferences>().getString(TODAY);
//      if(todayStr != null && DateTime.now().millisecondsSinceEpoch < int.parse(todayStr)){
//        _day = DateTime.fromMillisecondsSinceEpoch(int.parse(todayStr));
//      } else{
//        _day = DateTime.now();
//      }
//      today = DateFormat.yMd().format(_day).replaceAll("/", "0");
//      day = _day;
//    }
//    return _day.millisecondsSinceEpoch;
//  }


}