import 'package:course_sys/route/router_handler.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

/*
* Fluro路由配置
*
* */
class Application {
  static late final FluroRouter router;
}

/*
* 路由配置
*
* */
class Routers {
  static const String root = "/";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String teacherList = "/teacherList";
  static const String editCourse = "/editCourse";
  static const String courseDetail = "/courseDetail";
  static const String courseList = "/courseList";
  static const String courseOrderList = "/courseOrderList";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
          print("ROUTE WAS NOT FOUND !!!");
        });

    //路由定義
    //首頁
    router.define(root, handler: rootHandler);
    //登入頁
    router.define(login, handler: loginHandler, transitionType: TransitionType.fadeIn);
    //註冊頁
    router.define(signup, handler: signupHandler, transitionType: TransitionType.fadeIn);
    //老師列表頁
    router.define(teacherList, handler: teacherListHandler, transitionType: TransitionType.fadeIn);
    //新增編輯課程頁
    router.define(editCourse, handler: editCourseHandler, transitionType: TransitionType.fadeIn);
    //課程詳情頁
    router.define(courseDetail, handler: courseDetailHandler, transitionType: TransitionType.fadeIn);
    //選課清單頁
    router.define(courseList, handler: courseListHandler, transitionType: TransitionType.fadeIn);
    //課程選課清單列表頁
    router.define(courseOrderList, handler: courseOrderListHandler, transitionType: TransitionType.fadeIn);
  }
}