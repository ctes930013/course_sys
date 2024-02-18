import 'package:course_sys/model/course.dart';
import 'package:course_sys/service/course_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  late CourseService service;
  // Setup sqflite_common_ffi for flutter test
  setUpAll(() {
    // 初始化sqlite
    sqfliteFfiInit();
    // 改用test模式
    databaseFactory = databaseFactoryFfi;
    service = CourseService();
  });

  // tearDownAll(() async {
  //   //清除資料表
  //   String path = await getDatabasesPath();
  //   deleteDatabase(path);
  // });

  // Tests here
  test('Insert test', () async {
    await service.insert("計算機概論", "授予學生基本電腦知識", 1, 2, "09:00", "12:00");
  });

  test('Get all test', () async {
    List<Course>? data = await service.getAll();
    if (data != null) {
      for (var element in data) {
        print(element.toJson());
      }
    }
  });

  test('Get all by teacher test', () async {
    List<Course>? data = await service.getAllByTeacher(1, status: 1);
    if (data != null) {
      for (var element in data) {
        print(element.toJson());
      }
    }
  });

  test('Get test', () async {
    Course? data = await service.get(1);
    if (data != null) {
      print(data.toJson());
    }
  });

  test('Check time overlap', () async {
    expect(await service.checkTimeOverlap(1, 2, "10:00", "12:00"), 1);
  });

  test('Update', () async {
    await service.update(1, "計算機概論", "授予學生基本電腦知識及基本程式邏輯", 1, 2, "09:00", "12:00");
  });
}