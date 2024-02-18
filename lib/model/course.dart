/*
* 課程資料
*
* */
class Course {
  int? id;
  String? courseName;
  String? desc;
  int? teacherId;   //授課老師
  int? week;   //星期幾
  String? start;   //課程開始時間(14:00:00)
  String? end;    //課程結束時間(16:00:00)
  int? status;    //狀態，1:啟用 0:停用

  Course({this.id, this.courseName, this.desc, this.teacherId, this.week, this.start, this.end, this.status,});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseName = json['course_name'];
    desc = json['desc'];
    teacherId = json['teacher_id'];
    week = json['week'];
    start = json['start'];
    end = json['end'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['course_name'] = courseName;
    data['desc'] = desc;
    data['teacher_id'] = teacherId;
    data['week'] = week;
    data['start'] = start;
    data['end'] = end;
    data['status'] = status;
    return data;
  }
}

/*
* 課程資料陣列
*
* */
class CourseList {
  List<Course>? list;

  CourseList({this.list});

  CourseList.fromJson(List<dynamic> json) {
    list = [];
    for (dynamic map in json) {
      list!.add(Course.fromJson(map));
    }
  }

  List<Map<String, dynamic>> toJson() {
    List<Map<String, dynamic>> list = List.empty(growable: true);
    if (this.list != null) {
      for (var element in this.list!) {
        list.add(element.toJson());
      }
    }
    return list;
  }
}