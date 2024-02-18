import 'package:course_sys/constants/Constants.dart';
import 'package:course_sys/route/router.dart';
import 'package:course_sys/viewmodel/course_detail_view_model.dart';
import 'package:course_sys/viewmodel/course_order_view_model.dart';
import 'package:course_sys/widget/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

/*
* 課程詳情頁
* courseId: 課程id
* */
class CourseDetailPage extends StatefulWidget {
  final int courseId;
  const CourseDetailPage({super.key, required this.courseId,});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {

  late CourseDetailViewModel _courseViewModel;
  late CourseOrderViewModel _courseOrderViewModel;

  @override
  void initState() {
    _courseViewModel = Provider.of<CourseDetailViewModel>(context, listen: false);
    _courseOrderViewModel = Provider.of<CourseOrderViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _courseViewModel.init(widget.courseId);
      _courseOrderViewModel.getStudentCourseOrder(widget.courseId, Constants.userId!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
          title: "課程詳情",
          rightWidget: Selector<CourseDetailViewModel, int?>(
            selector: (_, model) => model.course?.teacherId,
            builder: (_, data, __) {
                  return Constants.userType == Constants.teacher &&
                      (data ?? 0) == Constants.userId ? InkWell(
                    onTap: () {
                      //跳轉該課程選課清單
                      Application.router.navigateTo(context,
                          "${Routers.courseOrderList}?course_id=${widget.courseId}");
                    },
                    child: const Icon(
                        Icons.library_books,
                        size: 20,
                        color: Colors.black87
                    ),
                  ) : const SizedBox();
            }),
        ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //課程名稱
            Row(
              children: [
                const Text(
                  "課程名稱:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4,),
                Selector<CourseDetailViewModel, String>(
                  selector: (_, model) => model.course?.courseName ?? "",
                  builder: (_, data, __) {
                    return Text(
                      data,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    );
                  }),
              ],
            ),
            const SizedBox(height: 4,),
            //授課老師
            Row(
              children: [
                const Text(
                  "授課老師:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4,),
                Selector<CourseDetailViewModel, String?>(
                    selector: (_, model) => model.teacher?.name,
                    builder: (_, data, __) {
                      return Text(
                        data ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      );
                    }),
              ],
            ),
            const SizedBox(height: 4,),
            //上課時段
            Row(
              children: [
                const Text(
                  "上課時段:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4,),
                Selector<CourseDetailViewModel, Tuple3<int?, String?, String?>>(
                    selector: (_, model) => Tuple3(
                        model.course?.week,
                        model.course?.start,
                        model.course?.end,
                    ),
                    builder: (_, data, __) {
                      return Text(
                        "${Constants.getWeekEng(data.item1 ?? 0)} ${data.item2} ~ ${data.item3}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      );
                    }),
              ],
            ),
            const SizedBox(height: 4,),
            //課程詳情
            const Text(
              "課程詳情:",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            Expanded(
              child: Selector<CourseDetailViewModel, String?>(
                  selector: (_, model) => model.course?.desc,
                  builder: (_, data, __) {
                    return SingleChildScrollView(
                      child: Text(
                        data ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 8,),
            //按鈕
            Selector2<CourseDetailViewModel, CourseOrderViewModel, Tuple2<int?, int?>>(
              selector: (_, detailModel, orderModel) => Tuple2(
                  detailModel.course?.status, orderModel.currentStudentCourseOrder?.status ?? 0),
              builder: (_, data, __) {
                return (Constants.userType == Constants.teacher
                    && (_courseViewModel.course?.teacherId ?? 0) != Constants.userId)
                    ? const SizedBox() : GestureDetector(
                  onTap: () async {
                    if (Constants.userType == Constants.teacher) {
                      //老師身分
                      Application.router.navigateTo(context,
                          "${Routers.editCourse}?course_id=${widget.courseId}");
                    } else {
                      //學生身分
                      await _courseOrderViewModel.selectCourse(
                          widget.courseId, Constants.userId!, isAdd: data.item2 == 0);
                      await _courseOrderViewModel.getStudentCourseOrder(widget.courseId, Constants.userId!);
                    }
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      color: Constants.userType == Constants.student ?
                      data.item1 == 1 ? Colors.blue : Colors.grey : Colors.blue,
                      alignment: Alignment.center,
                      child: Text(
                        Constants.userType == Constants.student ?
                        data.item1 == 1 ? data.item2 == 0 ? "我要加選這門課" : "我要退選這門課" : "本門課已被停止" : "編輯",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
            }),
          ],
        ),
      ),
    );
  }
}
