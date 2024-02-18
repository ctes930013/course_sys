import 'package:course_sys/model/student.dart';
import 'package:course_sys/service/student_service.dart';
import 'package:flutter/material.dart';

/*
* 學生列表的vm
* */
class StudentListViewModel extends ChangeNotifier {

  //學生列表
  List<Student> studentList = [];

  /*
  * 取得全部學生
  * */
  getAllList() async {
    StudentService studentService = StudentService();
    studentList = await studentService.getAll() ?? [];
    notifyListeners();
  }
}