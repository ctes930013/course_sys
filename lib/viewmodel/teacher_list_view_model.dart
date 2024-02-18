import 'package:course_sys/model/course.dart';
import 'package:course_sys/model/teacher.dart';
import 'package:course_sys/service/course_service.dart';
import 'package:course_sys/service/teacher_service.dart';
import 'package:flutter/material.dart';

/*
* 老師列表的vm
* */
class TeacherListViewModel extends ChangeNotifier {

  //老師列表
  List<Teacher> teacherList = [];
  //全部課程列表
  List<Course> courseList = [];
  //所有老師開的課程列表(key:老師id)
  Map<int, List<Course>> teacherCourseList = {};

  /*
  * 取得全部老師
  * */
  getAllList() async {
    TeacherService teacherService = TeacherService();
    teacherList = await teacherService.getAll() ?? [];
    CourseService courseService = CourseService();
    courseList = await courseService.getAll() ?? [];
    getTeacherCourse();
    notifyListeners();
  }

  /*
  * 篩選出老師開的課程
  * */
  getTeacherCourse() {
    for (var element in teacherList) {
      teacherCourseList[element.id!] = [];
    }
    for (var element in courseList) {
      teacherCourseList[element.teacherId!]?.add(element);
    }
  }
}