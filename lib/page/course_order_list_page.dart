import 'package:course_sys/model/course_order.dart';
import 'package:course_sys/model/student.dart';
import 'package:course_sys/viewmodel/course_order_view_model.dart';
import 'package:course_sys/viewmodel/student_list_view_model.dart';
import 'package:course_sys/widget/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

/*
* 課程選課清單列表頁
* courseId: 課程id
* */
class CourseOrderListPage extends StatefulWidget {
  final int courseId;
  const CourseOrderListPage({super.key, required this.courseId,});

  @override
  State<CourseOrderListPage> createState() => _CourseOrderListPageState();
}

class _CourseOrderListPageState extends State<CourseOrderListPage> {

  late CourseOrderViewModel _courseOrderViewModel;
  late StudentListViewModel _studentListViewModel;

  @override
  void initState() {
    _courseOrderViewModel = Provider.of<CourseOrderViewModel>(context, listen: false);
    _studentListViewModel = Provider.of<StudentListViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _courseOrderViewModel.getCourseOrderList(widget.courseId);
      _studentListViewModel.getAllList();
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
      appBar: const CommonAppBar(title: "選課名單"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Selector2<CourseOrderViewModel, StudentListViewModel, Tuple2<List, List>>(
            selector: (_, orderModel, studentModel) =>
                Tuple2(orderModel.courseOrderList.toList(), studentModel.studentList.toList()),
            builder: (_, data, __) {
              return ListView.builder(
                itemCount: data.item1.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  Student? student;
                  CourseOrder order = data.item1[i];
                  for (var element in data.item2) {
                    if (element.id == order.studentId) {
                      student = element;
                      break;
                    }
                  }
                  return Row(
                      children: [
                        //圖片
                        Image.asset(
                          "assets/img/profile.png",
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 10,),
                        //學生名字
                        Text(
                          student?.name ?? "",
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
