import 'package:course_sys/model/course.dart';
import 'package:course_sys/model/course_order.dart';
import 'package:course_sys/service/course_order_service.dart';
import 'package:course_sys/service/course_service.dart';
import 'package:course_sys/utils/toast.dart';
import 'package:flutter/material.dart';

/*
* 選課的vm
* */
class CourseOrderViewModel extends ChangeNotifier {

  //某學生某課程的選課結果
  CourseOrder? currentStudentCourseOrder;
  //某學生的所有選課結果
  List<CourseOrder> studentOrderList = [];
  //某課程的所有選課結果
  List<CourseOrder> courseOrderList = [];


  /*
  * 取得某學生的所有選課結果
  * studentId: 學生id
  * */
  getStudentOrderList(int studentId) async {
    CourseOrderService courseOrderService = CourseOrderService();
    studentOrderList = await courseOrderService.getAllByStudent(studentId) ?? [];
    notifyListeners();
  }

  /*
  * 取得某課程的所有選課結果
  * courseId: 課程id
  * status: 狀態
  * */
  getCourseOrderList(int courseId, {int status = 1}) async {
    CourseOrderService courseOrderService = CourseOrderService();
    courseOrderList = await courseOrderService.getAllByCourse(courseId, status: status) ?? [];
    notifyListeners();
  }

  /*
  * 取得某學生某課程的選課結果
  * courseId: 課程id
  * studentId: 學生id
  * */
  getStudentCourseOrder(int courseId, int studentId) async {
    CourseOrderService courseOrderService = CourseOrderService();
    currentStudentCourseOrder = await courseOrderService.getByStudentCourse(courseId, studentId);
    notifyListeners();
  }

  /*
  * 某學生選某一門課
  * courseId: 課程id
  * studentId: 學生id
  * isAdd: 加選還是退選(預設加選)
  * */
  selectCourse(int courseId, int studentId, {bool isAdd = true}) async {
    CourseOrderService courseOrderService = CourseOrderService();
    CourseService courseService = CourseService();
    //先查找有無該門課選課紀錄
    CourseOrder? order = await courseOrderService.getByStudentCourse(courseId, studentId);
    //取得該門課資訊
    Course? course = await courseService.get(courseId);
    if (course == null) {
      showToast("找不到該課程");
      return;
    }
    //判斷該時段是否和該學生其他課程衝突
    if (isAdd) {
      int overlapCourseId = await courseOrderService.checkTimeOverlap(
          studentId, course.week!, course.start!, course.end!);
      if (overlapCourseId != 0) {
        Course? overlapCourse = await courseService.get(overlapCourseId);
        showToast("已經和${overlapCourse?.courseName}的時段重複了");
        return;
      }
    }
    if (order != null) {
      //代表有
      await courseOrderService.update(order.id!, status: isAdd ? 1 : 0);
    } else {
      //代表沒有
      await courseOrderService.insert(courseId, studentId, status: isAdd ? 1 : 0);
    }
    showToast("成功");
  }
}