import 'package:course_sys/constants/Constants.dart';
import 'package:course_sys/model/course.dart';
import 'package:course_sys/model/course_order.dart';
import 'package:course_sys/model/teacher.dart';
import 'package:course_sys/route/router.dart';
import 'package:course_sys/viewmodel/course_order_view_model.dart';
import 'package:course_sys/viewmodel/teacher_list_view_model.dart';
import 'package:course_sys/widget/common_app_bar.dart';
import 'package:course_sys/widget/course_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

/*
* 學生選課列表頁
* */
class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {

  late CourseOrderViewModel _courseOrderViewModel;
  late TeacherListViewModel _teacherListViewModel;

  @override
  void initState() {
    _courseOrderViewModel = Provider.of<CourseOrderViewModel>(context, listen: false);
    _teacherListViewModel = Provider.of<TeacherListViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _courseOrderViewModel.getStudentOrderList(Constants.userId!);
      _teacherListViewModel.getAllList();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "選課清單"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Selector2<CourseOrderViewModel, TeacherListViewModel, Tuple2<List, List>>(
            selector: (_, orderModel, teacherModel) =>
                Tuple2(orderModel.studentOrderList.toList(), teacherModel.courseList.toList()),
            builder: (_, data, __) {
              return ListView.builder(
                itemCount: data.item2.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  Teacher? teacher;
                  CourseOrder? order;
                  Course course = data.item2[i];
                  for (var element in _teacherListViewModel.teacherList) {
                    if (element.id == course.teacherId) {
                      teacher = element;
                      break;
                    }
                  }
                  for (var element in data.item1) {
                    if (element.courseId == course.id) {
                      order = element;
                      break;
                    }
                  }
                  return CourseItemWidget(
                    course: course,
                    teacherName: teacher?.name ?? "",
                    customTrailWidget: selectCourseWidget(order, course),
                    clickEvent: () {
                      Application.router.navigateTo(context,
                        "${Routers.courseDetail}?course_id=${course.id}",).then((value) async {
                        await _courseOrderViewModel.getStudentOrderList(Constants.userId!);
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /*
  * 取得加退選課程按鈕
  * order: 課程加選資料
  * course: 課程資料
  * */
  selectCourseWidget(CourseOrder? order, Course course) {
    return GestureDetector(
      onTap: () async {
        await _courseOrderViewModel.selectCourse(
          course.id!,
          Constants.userId!,
          isAdd: !(order != null && order.status == 1),
        );
        await _courseOrderViewModel.getStudentOrderList(Constants.userId!);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          width: 90,
          height: 40,
          color: order != null && order.status == 1 ? Colors.pink : Colors.blue,
          alignment: Alignment.center,
          child: Text(
            order != null && order.status == 1 ? "退選" : "加選",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
