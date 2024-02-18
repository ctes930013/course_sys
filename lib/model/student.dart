/*
* 學生資料
*
* */
class Student {
  int? id;
  String? account;
  String? password;
  String? name;

  Student({this.id, this.account, this.password, this.name});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    account = json['account'];
    password = json['password'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['account'] = account;
    data['password'] = password;
    data['name'] = name;
    return data;
  }
}

/*
* 學生資料陣列
*
* */
class StudentList {
  List<Student>? list;

  StudentList({this.list});

  StudentList.fromJson(List<dynamic> json) {
    list = [];
    for (dynamic map in json) {
      list!.add(Student.fromJson(map));
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