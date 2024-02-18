/*
* 老師資料
*
* */
class Teacher {
  int? id;
  String? account;
  String? password;
  String? name;
  String? desc;

  Teacher({this.id, this.account, this.password, this.name, this.desc});

  Teacher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    account = json['account'];
    password = json['password'];
    name = json['name'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['account'] = account;
    data['password'] = password;
    data['name'] = name;
    data['desc'] = desc;
    return data;
  }
}

/*
* 老師資料陣列
*
* */
class TeacherList {
  List<Teacher>? list;

  TeacherList({this.list});

  TeacherList.fromJson(List<dynamic> json) {
    list = [];
    for (dynamic map in json) {
      list!.add(Teacher.fromJson(map));
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