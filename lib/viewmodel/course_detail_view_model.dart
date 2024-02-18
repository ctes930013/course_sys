import 'package:course_sys/model/course.dart';
import 'package:course_sys/model/teacher.dart';
import 'package:course_sys/service/course_service.dart';
import 'package:course_sys/service/teacher_service.dart';
import 'package:flutter/material.dart';

/*
* 課程詳情的vm
* */
class CourseDetailViewModel extends ChangeNotifier {

  //當前課程id
  int courseId = 0;
  //當前課程資料
  Course? course;
  //授課老師資訊
  Teacher? teacher;

  /*
  * 初始化
  * courseId: 課程id
  * */
  init(int courseId) async {
    this.courseId = courseId;
    await getCourseData();
  }

  /*
  * 取得課程資訊
  * */
  getCourseData() async {
    CourseService courseService = CourseService();
    TeacherService teacherService = TeacherService();
    course = await courseService.get(courseId);
    if (course != null) {
      teacher = await teacherService.get(course?.teacherId ?? 0);
    }
    notifyListeners();
  }

  /*
  * 選這門課
  * */
  selectCourse() async {

  }
}