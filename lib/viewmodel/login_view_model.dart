import 'package:course_sys/constants/Constants.dart';
import 'package:course_sys/main.dart';
import 'package:course_sys/model/student.dart';
import 'package:course_sys/model/teacher.dart';
import 'package:course_sys/route/router.dart';
import 'package:course_sys/service/student_service.dart';
import 'package:course_sys/service/teacher_service.dart';
import 'package:course_sys/utils/toast.dart';
import 'package:flutter/material.dart';

/*
* 登入註冊的vm
* */
class LoginViewModel extends ChangeNotifier {

  //身分
  String type = Constants.student;
  late BuildContext context;
  late TeacherService teacherService;
  late StudentService studentService;

  /*
  * 初始化
  * context
  * type: 身分
  * */
  init(BuildContext context, String type) {
    this.context = context;
    this.type = type;
    teacherService = TeacherService();
    studentService = StudentService();
  }

  /*
  * 登入
  * account: 帳號
  * password: 密碼
  * */
  login(String account, String password) async {
    if (!Constants.validCharacters.hasMatch(account)) {
      showToast("帳號含有非法字元");
      return;
    }
    if (!Constants.validCharacters.hasMatch(password)) {
      showToast("密碼含有非法字元");
      return;
    }
    if (type == Constants.teacher) {
      //老師登入
      Teacher? teacher = await teacherService.verify(account, password);
      if (teacher != null) {
        //登入成功
        if (context.mounted) {
          setValue(teacher.id!, teacher.name ?? "");
          Application.router.navigateTo(context,
            Routers.teacherList, clearStack: true);
        }
      } else {
        //登入失敗
        showToast("帳號密碼錯誤");
      }
    } else {
      //學生登入
      Student? student = await studentService.verify(account, password);
      if (student != null) {
        //登入成功
        if (context.mounted) {
          setValue(student.id!, student.name ?? "");
          Application.router.navigateTo(context,
            Routers.teacherList, clearStack: true);
        }
      } else {
        //登入失敗
        showToast("帳號密碼錯誤");
      }
    }
  }

  /*
  * 註冊
  * account: 帳號
  * password: 密碼
  * name: 姓名
  * desc: 介紹
  * */
  signup(String account, String password, String name, {String desc = ""}) async {
    if (account == "") {
      showToast("帳號不能為空");
      return;
    }
    if (password == "") {
      showToast("密碼不能為空");
      return;
    }
    if (name == "") {
      showToast("姓名不能為空");
      return;
    }
    if (!Constants.validCharacters.hasMatch(account)) {
      showToast("帳號含有非法字元");
      return;
    }
    if (!Constants.validCharacters.hasMatch(password)) {
      showToast("密碼含有非法字元");
      return;
    }
    if (type == Constants.teacher) {
      //老師註冊
      bool isExist = await teacherService.checkAccountExists(account);
      if (isExist) {
        showToast("該帳號已存在");
        return;
      }
      int code = await teacherService.insert(account, password, name, desc);
      if (code != 0) {
        //註冊成功
        showToast("註冊成功");
        login(account, password);
      } else {
        //註冊失敗
        showToast("註冊失敗");
      }
    } else {
      //學生註冊
      bool isExist = await studentService.checkAccountExists(account);
      if (isExist) {
        showToast("該帳號已存在");
        return;
      }
      int code = await studentService.insert(account, password, name);
      if (code != 0) {
        //註冊成功
        showToast("註冊成功");
        login(account, password);
      } else {
        //註冊失敗
        showToast("註冊失敗");
      }
    }
  }

  /*
  * 註冊
  * userId: 用戶id
  * userName: 用戶名稱
  * */
  setValue(int userId, String userName) {
    Constants.userId = userId;
    Constants.userName = userName;
    Constants.userType = type;
    //存入偏好
    sharePref.setInt(Constants.userIdKey, userId);
    sharePref.setString(Constants.userNameKey, userName);
    sharePref.setString(Constants.userTypeKey, type);
  }
}