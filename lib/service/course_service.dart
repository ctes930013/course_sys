import 'package:course_sys/database/base_db.dart';
import 'package:course_sys/database/sql_config.dart';
import 'package:course_sys/model/course.dart';

/*
* 存取課程資料表相關類
*
* */
class CourseService extends BaseDb {

  /*
  * 初始化
  * */
  initial() async {
    await super.init();
  }

  /*
  * 新增資料
  * courseName: 課程名稱
  * desc: 簡介
  * teacherId: 授課老師
  * week: 星期幾
  * start: 開始時間
  * end: 結束時間
  * status: 狀態，1:啟用 0:停用(預設啟用)
  * */
  Future<int> insert(String courseName, String desc, int teacherId, int week, String start, String end, {int status = 1}) async {
    await initial();
    int id = 0;
    await db.transaction((txn) async {
      id = await txn.rawInsert(
          'INSERT INTO ${SqlConfig.dbCourse} '
              '(course_name, desc, teacher_id, week, start, end, status) VALUES '
              '("$courseName", "$desc", "$teacherId", "$week", "$start", "$end", "$status")'
      );
    });
    await close();
    return id;
  }

  /*
  * 取得所有資料
  * status: 是否篩選狀態，-1代表不篩選
  * */
  Future<List<Course>?> getAll({int status = -1}) async {
    await initial();
    String sql = 'SELECT * FROM ${SqlConfig.dbCourse}';
    if (status != -1) {
      sql += ' WHERE status = $status';
    }
    List<Map> data = await db.rawQuery(sql);
    CourseList list = CourseList.fromJson(data);
    await close();
    return list.list;
  }

  /*
  * 取得某筆資料
  * id
  * */
  Future<Course?> get(int id) async {
    await initial();
    List<Map> data = await db.rawQuery('SELECT * FROM ${SqlConfig.dbCourse} WHERE id = $id');
    CourseList list = CourseList.fromJson(data);
    await close();
    if (list.list != null && list.list!.isNotEmpty) {
      return list.list![0];
    }
    return null;
  }

  /*
  * 取得某老師所有開課資料
  * teacherId: 授課老師
  * status: 是否篩選狀態，-1代表不篩選
  * */
  Future<List<Course>?> getAllByTeacher(int teacherId, {int status = -1}) async {
    await initial();
    String sql = 'SELECT * FROM ${SqlConfig.dbCourse} WHERE teacher_id = $teacherId';
    if (status != -1) {
      sql += ' AND status = $status';
    }
    List<Map> data = await db.rawQuery(sql);
    CourseList list = CourseList.fromJson(data);
    await close();
    return list.list;
  }

  /*
  * 檢查某老師開課的課程時間是否與現有課程重疊
  * teacherId: 授課老師
  * week: 星期幾
  * startTime: 開始時間(15:00)
  * endTime: 結束時間(17:00)
  * filterCourseId: 要過濾掉不用判斷的課程id
  * 回傳0代表沒有重疊，其餘則回傳重疊的課程id
  * */
  Future<int> checkTimeOverlap(int teacherId, int week, String startTime, String endTime, {int? filterCourseId}) async {
    List<Course>? dataAll = await getAllByTeacher(teacherId, status: 1);
    int overlapCourse = 0;
    if (dataAll != null) {
      for (var element in dataAll) {
        if (week != element.week || (filterCourseId != null && filterCourseId == element.id)) {
          //略過不同星期及指定過濾課程
          continue;
        }
        DateTime start = DateTime.parse("2024-01-01 $startTime");   //日期不重要
        DateTime end = DateTime.parse("2024-01-01 $endTime");
        DateTime currentStart = DateTime.parse("2024-01-01 ${element.start}");
        DateTime currentEnd = DateTime.parse("2024-01-01 ${element.end}");
        if (!(end.isBefore(currentStart) || start.isAfter(currentEnd))) {
          overlapCourse = element.id!;
          break;
        }
      }
    }
    return overlapCourse;
  }

  /*
  * 更新某筆資料
  * id
  * courseName: 課程名稱
  * desc: 簡介
  * teacherId: 授課老師
  * week: 星期幾
  * start: 開始時間
  * end: 結束時間
  * status: 狀態，1:啟用 0:停用(預設啟用)
  * */
  update(int id, String courseName, String desc, int teacherId, int week, String start, String end, {int status = 1}) async {
    await initial();
    await db.update(
        SqlConfig.dbCourse,
        {
          'course_name': courseName,
          'desc': desc,
          'teacher_id': teacherId,
          'week': week,
          'start': start,
          'end': end,
          'status': status,
        },
        where: 'id = ?',
        whereArgs: [id]
    );
    await close();
  }

  /*
  * 移除資料
  * id
  * */
  delete(int id) async {
    await initial();
    await db.transaction((txn) async {
      await txn.rawDelete(
          'DELETE FROM ${SqlConfig.dbCourse} WHERE id = ?', [id]
      );
    });
    await close();
  }
}