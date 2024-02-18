import 'package:course_sys/constants/Constants.dart';
import 'package:course_sys/page/course_detail_page.dart';
import 'package:course_sys/page/course_list_page.dart';
import 'package:course_sys/page/course_order_list_page.dart';
import 'package:course_sys/page/edit_course_page.dart';
import 'package:course_sys/page/home_page.dart';
import 'package:course_sys/page/login_page.dart';
import 'package:course_sys/page/signup_page.dart';
import 'package:course_sys/page/teacher_list_page.dart';
import 'package:course_sys/viewmodel/course_detail_view_model.dart';
import 'package:course_sys/viewmodel/course_order_view_model.dart';
import 'package:course_sys/viewmodel/edit_course_view_model.dart';
import 'package:course_sys/viewmodel/login_view_model.dart';
import 'package:course_sys/viewmodel/student_list_view_model.dart';
import 'package:course_sys/viewmodel/teacher_list_view_model.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
* 路由Handler配置
*
* */

//首頁
var rootHandler = Handler(handlerFunc: (BuildContext? context, params) {
  return const HomePage();
});

//登入頁
var loginHandler = Handler(handlerFunc: (BuildContext? context, params) {
  final String? type = params['type']?.first;
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel()),
    ],
    child: LoginPage(type: type ?? Constants.student),
  );
});

//註冊頁
var signupHandler = Handler(handlerFunc: (BuildContext? context, params) {
  final String? type = params['type']?.first;
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel()),
    ],
    child: SingupPage(type: type ?? Constants.student),
  );
});

//老師列表頁
var teacherListHandler = Handler(handlerFunc: (BuildContext? context, params) {
  return const TeacherListPage();
});

//新增編輯課程頁
var editCourseHandler = Handler(handlerFunc: (BuildContext? context, params) {
  final int courseId = int.parse(params['course_id']?.first ?? "0");
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<EditCourseViewModel>(
          create: (context) => EditCourseViewModel()),
    ],
    child: EditCoursePage(courseId: courseId),
  );
});

//課程詳情頁
var courseDetailHandler = Handler(handlerFunc: (BuildContext? context, params) {
  final int courseId = int.parse(params['course_id']?.first ?? "0");
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<CourseDetailViewModel>(
          create: (context) => CourseDetailViewModel()),
      ChangeNotifierProvider<CourseOrderViewModel>(
          create: (context) => CourseOrderViewModel()),
    ],
    child: CourseDetailPage(courseId: courseId),
  );
});

//選課清單頁
var courseListHandler = Handler(handlerFunc: (BuildContext? context, params) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<CourseOrderViewModel>(
          create: (context) => CourseOrderViewModel()),
    ],
    child: const CourseListPage(),
  );
});

//課程選課清單列表頁
var courseOrderListHandler = Handler(handlerFunc: (BuildContext? context, params) {
  final int courseId = int.parse(params['course_id']?.first ?? "0");
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<StudentListViewModel>(
          create: (context) => StudentListViewModel()),
      ChangeNotifierProvider<CourseOrderViewModel>(
          create: (context) => CourseOrderViewModel()),
    ],
    child: CourseOrderListPage(courseId: courseId),
  );
});