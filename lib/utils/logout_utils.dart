import 'package:course_sys/constants/Constants.dart';
import 'package:course_sys/main.dart';

/*
* 登出相關類
* */
class LogoutUtils {

  /*
  * 清除本地資料
  * */
  static clear() {
    Constants.userId = null;
    Constants.userName = null;
    Constants.userType = null;
    //清除偏好
    sharePref.remove(Constants.userIdKey);
    sharePref.remove(Constants.userNameKey);
    sharePref.remove(Constants.userTypeKey);
  }
}