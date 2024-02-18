import 'package:course_sys/model/course.dart';
import 'package:course_sys/route/router.dart';
import 'package:course_sys/service/course_order_service.dart';
import 'package:course_sys/service/course_service.dart';
import 'package:course_sys/utils/toast.dart';
import 'package:course_sys/viewmodel/teacher_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
* 新增或編輯課程的vm
* */
class EditCourseViewModel extends ChangeNotifier {

  //定義星期
  final List<String> weekItems = [
    '星期一',
    '星期二',
    '星期三',
    '星期四',
    '星期五',
    '星期六',
  ];
  //選擇星期幾
  int selectedWeekIndex = 0;

  //定義上課時間區間
  final List<String> startTimeItems = [
    '08:10',
    '09:10',
    '10:10',
    '11:10',
    '12:10',
    '13:10',
    '14:10',
    '15:10',
    '16:10',
    '17:10',
    '18:10',
    '19:10',
    '20:10',
    '21:10',
  ];
  //定義下課時間區間
  final List<String> endTimeItems = [
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00',
  ];
  //選擇上課時間
  String selectedStartTime = "";
  //選擇下課時間
  String selectedEndTime = "";
  //狀態
  bool isEnabled = true;
  late BuildContext context;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  //當前課程資料
  Course? course;

  /*
  * 建構子
  * */
  EditCourseViewModel() {
    selectedStartTime = startTimeItems[0];
    selectedEndTime = endTimeItems[1];
  }

  /*
  * 初始化
  * */
  init(BuildContext context) {
    this.context = context;
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  /*
  * 取得當前課程資料
  * courseId: 當前課程id
  * */
  getCourseData(int courseId) async {
    CourseService courseService = CourseService();
    course = await courseService.get(courseId);
    if (course != null) {
      nameController.text = course!.courseName ?? "";
      descController.text = course!.desc ?? "";
      selectedWeekIndex = course!.week! - 1;
      selectedStartTime = course!.start!;
      selectedEndTime = course!.end!;
      isEnabled = course!.status == 1;
    }
    notifyListeners();
  }

  /*
  * 設置選擇的星期
  * item: 選擇星期幾
  * */
  setSelectedWeek(String item) {
    selectedWeekIndex = weekItems.lastIndexOf(item);
    notifyListeners();
  }

  /*
  * 設置選擇的上課時間
  * item: 選擇幾點上課
  * */
  setSelectedStartTime(String item) {
    selectedStartTime = item;
    notifyListeners();
  }

  /*
  * 設置選擇的下課時間
  * item: 選擇幾點下課
  * */
  setSelectedEndTime(String item) {
    selectedEndTime = item;
    notifyListeners();
  }

  /*
  * 設置狀態
  * isEnabled: 是否啟用
  * */
  setStatus(bool isEnabled) {
    this.isEnabled = isEnabled;
    notifyListeners();
  }

  /*
  * 新增編輯課程
  * teacherId: 授課老師id
  * courseId: 要編輯的課程id，如果是0代表是新增
  * */
  addCourse(int teacherId, int courseId) async {
    String name = nameController.text;
    String desc = descController.text;
    if (name == "") {
      showToast("課程名稱不能為空");
      return;
    }
    DateTime start = DateTime.parse("2024-01-01 $selectedStartTime");
    DateTime end = DateTime.parse("2024-01-01 $selectedEndTime");
    if (end.isBefore(start) || end.isAtSameMomentAs(start)) {
      showToast("下課時間不得早於上課時間");
      return;
    }
    int selectedWeek = selectedWeekIndex + 1;
    CourseService courseService = CourseService();
    int overlapCourseId = await courseService.checkTimeOverlap(teacherId, selectedWeek,
        selectedStartTime, selectedEndTime, filterCourseId: courseId == 0 ? null : courseId);
    if (overlapCourseId != 0) {
      Course? course = await courseService.get(overlapCourseId);
      showToast("已經和${course?.courseName}的時段重複了");
      return;
    }
    if (courseId == 0) {
      //新增
      await courseService.insert(name, desc, teacherId,
          selectedWeek, selectedStartTime, selectedEndTime, status: isEnabled ? 1 : 0);
      showToast("新增成功");
      //跳轉回上一頁
      if (context.mounted) {
        //重新刷新課程列表
        Provider.of<TeacherListViewModel>(context, listen: false).getAllList();
        Application.router.pop(context);
      }
    } else {
      //編輯
      await courseService.update(courseId, name, desc, teacherId,
          selectedWeek, selectedStartTime, selectedEndTime, status: isEnabled ? 1 : 0);
      showToast("編輯成功");
      if (context.mounted) {
        Application.router.navigateTo(context,
            Routers.teacherList, clearStack: true);
      }
    }
  }

  /*
  * 移除課程
  * courseId: 要移除的課程id
  * */
  deleteCourse(int courseId) async {
    CourseService courseService = CourseService();
    CourseOrderService courseOrderService = CourseOrderService();
    //先移除有選本門課的選課資料
    await courseOrderService.deleteByCourse(courseId);
    await courseService.delete(courseId);
  }
}