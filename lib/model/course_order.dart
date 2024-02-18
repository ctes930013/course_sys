/*
* 學生選課資料
*
* */
class CourseOrder {
  int? id;
  int? courseId;    //課程id
  int? studentId;   //學生id
  int? status;    //狀態，1:啟用 0:停用

  CourseOrder({this.id, this.courseId, this.studentId, this.status,});

  CourseOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    studentId = json['student_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['course_id'] = courseId;
    data['student_id'] = studentId;
    data['status'] = status;
    return data;
  }
}

/*
* 學生選課資料陣列
*
* */
class CourseOrderList {
  List<CourseOrder>? list;

  CourseOrderList({this.list});

  CourseOrderList.fromJson(List<dynamic> json) {
    list = [];
    for (dynamic map in json) {
      list!.add(CourseOrder.fromJson(map));
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