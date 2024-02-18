import 'package:course_sys/constants/Constants.dart';
import 'package:course_sys/model/course.dart';
import 'package:flutter/material.dart';

/*
* 課程項元件
* course: 課程資料
* teacherName: 授課老師名稱
* customTrailWidget: 自定義最右邊的widget
* clickEvent: 點擊事件
* */
class CourseItemWidget extends StatelessWidget {
  final Course course;
  final String teacherName;
  final Widget? customTrailWidget;
  final Function? clickEvent;
  const CourseItemWidget({super.key, required this.course,
    required this.teacherName, this.customTrailWidget, this.clickEvent,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (clickEvent != null) {
          clickEvent!();
        }
      },
      child: Row(
        children: [
          //圖片
          Image.asset(
            "assets/img/book.png",
            width: 70,
            height: 70,
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //課程名稱
                Text(
                  course.courseName ?? "",
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4,),
                //授課老師
                Text(
                  teacherName,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4,),
                //上課時段
                Text(
                  "${Constants.getWeekEng(course.week!)} ${course.start} ~ ${course.end}",
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          //倘若沒有自定義元件預設顯示箭頭
          customTrailWidget != null ? customTrailWidget! : const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.black87
          ),
        ],
      ),
    );
  }
}
