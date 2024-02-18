import 'package:course_sys/constants/Constants.dart';
import 'package:course_sys/model/course.dart';
import 'package:course_sys/model/teacher.dart';
import 'package:course_sys/route/router.dart';
import 'package:course_sys/utils/logout_utils.dart';
import 'package:course_sys/viewmodel/teacher_list_view_model.dart';
import 'package:course_sys/widget/course_item_widget.dart';
import 'package:course_sys/widget/teacher_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

/*
* 老師列表頁
* */
class TeacherListPage extends StatefulWidget {
  const TeacherListPage({super.key});

  @override
  State<TeacherListPage> createState() => _TeacherListPageState();
}

class _TeacherListPageState extends State<TeacherListPage> {

  late TeacherListViewModel _teacherViewModel;

  @override
  void initState() {
    _teacherViewModel = Provider.of<TeacherListViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _teacherViewModel.getAllList();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "您好! ${Constants.userName}",
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2,),
                      //登出
                      InkWell(
                        onTap: () {
                          LogoutUtils.clear();
                          Application.router.navigateTo(context,
                              Routers.root, clearStack: true);
                        },
                        child: const Text(
                          "登出",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (Constants.userType == Constants.teacher) {
                        Application.router.navigateTo(context,
                            Routers.editCourse);
                      } else {
                        Application.router.navigateTo(context,
                            Routers.courseList);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: Container(
                        width: 100,
                        height: 45,
                        color: Colors.blue,
                        alignment: Alignment.center,
                        child: Text(
                          Constants.userType == Constants.teacher ? "新增課程" : "選課清單",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //老師列表
              Expanded(
                child: Center(
                  child: Selector<TeacherListViewModel, Tuple2<List, Map>>(
                    selector: (_, model) => Tuple2(model.teacherList.toList(), model.teacherCourseList),
                    builder: (_, data, __) {
                      return ListView.builder(
                        itemCount: data.item1.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          Teacher teacher = data.item1[i];
                          List<Course> courseList = data.item2[teacher.id!];
                          return Theme(
                            //隱藏分割線
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: TeacherItemWidget(
                                  teacher: teacher
                              ),
                              children: <Widget>[
                                //該老師開的課程列表
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                  child: ListView.builder(
                                    itemCount: courseList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Course course = courseList[index];
                                      return CourseItemWidget(
                                        course: course,
                                        teacherName: teacher.name ?? "",
                                        clickEvent: () {
                                          Application.router.navigateTo(context,
                                            "${Routers.courseDetail}?course_id=${course.id}",);
                                        },
                                      );
                                    }
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
