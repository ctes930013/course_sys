import 'package:course_sys/model/course_order.dart';
import 'package:course_sys/service/course_order_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  late CourseOrderService service;
  // Setup sqflite_common_ffi for flutter test
  setUpAll(() {
    // 初始化sqlite
    sqfliteFfiInit();
    // 改用test模式
    databaseFactory = databaseFactoryFfi;
    service = CourseOrderService();
  });

  // tearDownAll(() async {
  //   //清除資料表
  //   String path = await getDatabasesPath();
  //   deleteDatabase(path);
  // });

  // Tests here
  test('Insert test', () async {
    await service.insert(1, 1);
  });

  test('Get all test', () async {
    List<CourseOrder>? data = await service.getAll();
    if (data != null) {
      for (var element in data) {
        print(element.toJson());
      }
    }
  });

  test('Get all by student course test', () async {
    CourseOrder? data = await service.getByStudentCourse(2, 1);
    if (data != null) {
      print(data.toJson());
    }
  });

  test('Get all by course test', () async {
    List<CourseOrder>? data = await service.getAllByCourse(1, status: 1);
    if (data != null) {
      for (var element in data) {
        print(element.toJson());
      }
    }
  });

  test('Get all by student test', () async {
    List<CourseOrder>? data = await service.getAllByStudent(1, status: 1);
    if (data != null) {
      for (var element in data) {
        print(element.toJson());
      }
    }
  });

  test('Get test', () async {
    CourseOrder? data = await service.get(1);
    if (data != null) {
      print(data.toJson());
    }
  });

  test('Check repeat', () async {
    expect(await service.checkRepeat(1, 1), true);
  });

  test('Check time overlap', () async {
    expect(await service.checkTimeOverlap(1, 2, "13:00", "16:00"), 0);
  });

  test('Update', () async {
    await service.update(1, status: 0);
  });

  test('Delete course', () async {
    await service.deleteByCourse(3);
  });
}