/*
* 通用常數
*
* */
class Constants {
  static const String teacher = "TEACHER";
  static const String student = "STUDENT";
  static final validCharacters = RegExp(r'^[a-zA-Z0-9_@%*^$~]+$');   //合法字符
  static int? userId;    //當前登入用戶id
  static String? userName;   //當前登入用戶名稱
  static String? userType;   //當前登入用戶身分是老師還是學生
  static const String userIdKey = "user_id";
  static const String userNameKey = "user_name";
  static const String userTypeKey = "user_type";

  /*
  * 根據星期幾取得對應的英文星期
  * week: 星期幾
  * */
  static String getWeekEng(int week) {
    String weekStr = "";
    switch (week) {
      case 1:
        weekStr = "Mon";
        break;
      case 2:
        weekStr = "Tue";
        break;
      case 3:
        weekStr = "Wed";
        break;
      case 4:
        weekStr = "Thu";
        break;
      case 5:
        weekStr = "Fri";
        break;
      case 6:
        weekStr = "Sat";
        break;
      case 7:
        weekStr = "Sun";
        break;
      default:
        break;
    }
    return weekStr;
  }
}