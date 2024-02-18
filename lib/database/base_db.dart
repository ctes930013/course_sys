import 'package:course_sys/database/sql_config.dart';
import 'package:sqflite/sqflite.dart';

/*
* 資料庫的基礎類別
*
* */
class BaseDb {

  late Database db;

  /*
  * 初始化並開啟連線
  *
  * */
  init() async {
    db = await openDatabase(SqlConfig.dbName, version: SqlConfig.dbVersion,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        // 建立老師資料表
        await db.execute(
            'CREATE TABLE IF NOT EXISTS '
                '${SqlConfig.dbTeacher} ('
                  'id INTEGER PRIMARY KEY, '
                  'account VARCHAR(100), '    //帳號
                  'password VARCHAR(100), '   //密碼
                  'name VARCHAR(30),'    //老師名稱
                  'desc TEXT'    //老師簡介
                ')'
        );
        // 建立學生資料表
        await db.execute(
            'CREATE TABLE IF NOT EXISTS '
                '${SqlConfig.dbStudent} ('
                'id INTEGER PRIMARY KEY, '
                'account VARCHAR(100), '    //帳號
                'password VARCHAR(100), '   //密碼
                'name VARCHAR(30)'    //學生名稱
              ')'
        );
        // 建立課程資料表
        await db.execute(
            'CREATE TABLE IF NOT EXISTS '
                '${SqlConfig.dbCourse} ('
                'id INTEGER PRIMARY KEY, '
                'course_name VARCHAR(100), '    //課程名稱
                'desc TEXT, '   //課程介紹
                'teacher_id INTEGER, '    //授課老師
                'week INTEGER(2), '    //課程開在禮拜幾
                'start VARCHAR(10), '    //課程開始時間(14:00)
                'end VARCHAR(10), '    //課程結束時間(16:00)
                'status INTEGER(2) NOT NULL DEFAULT 1'    //狀態，1:啟用 0:停用
              ')'
        );
        // 建立學生選課資料表
        await db.execute(
            'CREATE TABLE IF NOT EXISTS '
                '${SqlConfig.dbCourseOrder} ('
                'id INTEGER PRIMARY KEY, '
                'course_id INTEGER, '    //課程id
                'student_id INTEGER, '   //學生id
                'status INTEGER(2) NOT NULL DEFAULT 1'    //狀態，1:成功選課 0:退選
                ')'
        );
      },
    );
  }

  /*
  * 關閉連線
  *
  * */
  close() async {
    await db.close();
  }
}