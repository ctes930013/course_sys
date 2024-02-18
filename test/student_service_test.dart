import 'package:course_sys/model/student.dart';
import 'package:course_sys/service/student_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  late StudentService service;
  // Setup sqflite_common_ffi for flutter test
  setUpAll(() {
    // 初始化sqlite
    sqfliteFfiInit();
    // 改用test模式
    databaseFactory = databaseFactoryFfi;
    service = StudentService();
  });

  // Tests here
  test('Insert test', () async {
    await service.insert("test", "123456", "黃同學");
  });

  test('Get all test', () async {
    List<Student>? data = await service.getAll();
    if (data != null) {
      for (var element in data) {
        print(element.toJson());
      }
    }
  });

  test('Get test', () async {
    Student? data = await service.get(1);
    if (data != null) {
      print(data.toJson());
    }
  });

  test('Verify', () async {
    expect(await service.verify("test", "123456789"), null);
  });

  test('Check account exist', () async {
    expect(await service.checkAccountExists("test"), true);
  });

  test('Update password', () async {
    await service.updatePassword(1, "12345678");
  });

  test('Update name', () async {
    await service.updateName(1, "黃大同");
  });
}