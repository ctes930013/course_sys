import 'package:course_sys/model/teacher.dart';
import 'package:flutter/material.dart';

/*
* 老師項元件
* teacher: 老師資料
* */
class TeacherItemWidget extends StatelessWidget {
  final Teacher teacher;
  const TeacherItemWidget({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //頭像
        Image.asset(
          "assets/img/profile.png",
          width: 70,
          height: 70,
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //老師名稱
              Text(
                teacher.name ?? "",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4,),
              //老師簡介
              Text(
                teacher.desc ?? "",
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
