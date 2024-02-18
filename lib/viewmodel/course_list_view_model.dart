import 'package:course_sys/model/course.dart';
import 'package:course_sys/service/course_service.dart';
import 'package:flutter/material.dart';

/*
* 課程列表的vm
* */
class CourseListViewModel extends ChangeNotifier {

  //課程列表
  List<Course> courseList = [];

  /*
  * 取得全部老師
  * */
  getAllList() async {
    CourseService courseService = CourseService();
    courseList = await courseService.getAll() ?? [];
    notifyListeners();
  }
}