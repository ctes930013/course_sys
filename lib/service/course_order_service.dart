import 'package:course_sys/database/base_db.dart';
import 'package:course_sys/database/sql_config.dart';
import 'package:course_sys/model/course.dart';
import 'package:course_sys/model/course_order.dart';
import 'package:course_sys/service/course_service.dart';

/*
* 存取學生選課資料表相關類
*
* */
class CourseOrderService extends BaseDb {

  /*
  * 初始化
  * */
  initial() async {
    await super.init();
  }

  /*
  * 新增資料
  * courseId: 課程id
  * studentId: 學生id
  * status: 狀態，1:成功選課 0:退選(預設成功選課)
  * */
  Future<int> insert(int courseId, int studentId, {int status = 1}) async {
    await initial();
    int id = 0;
    await db.transaction((txn) async {
      id = await txn.rawInsert(
          'INSERT INTO ${SqlConfig.dbCourseOrder} '
              '(course_id, student_id, status) VALUES '
              '("$courseId", "$studentId", "$status")'
      );
    });
    await close();
    return id;
  }

  /*
  * 取得所有資料
  * status: 是否篩選狀態，-1代表不篩選
  * */
  Future<List<CourseOrder>?> getAll({int status = -1}) async {
    await initial();
    String sql = 'SELECT * FROM ${SqlConfig.dbCourseOrder}';
    if (status != -1) {
      sql += ' WHERE status = $status';
    }
    List<Map> data = await db.rawQuery(sql);
    CourseOrderList list = CourseOrderList.fromJson(data);
    await close();
    return list.list;
  }

  /*
  * 取得某筆資料
  * id
  * */
  Future<CourseOrder?> get(int id) async {
    await initial();
    List<Map> data = await db.rawQuery('SELECT * FROM ${SqlConfig.dbCourseOrder} WHERE id = $id');
    CourseOrderList list = CourseOrderList.fromJson(data);
    await close();
    if (list.list != null && list.list!.isNotEmpty) {
      return list.list![0];
    }
    return null;
  }

  /*
  * 取得某學生某課程的選課資料
  * courseId: 課程id
  * studentId: 學生id
  * */
  Future<CourseOrder?> getByStudentCourse(int courseId, int studentId) async {
    await initial();
    List<Map> data = await db.rawQuery('SELECT * FROM ${SqlConfig.dbCourseOrder} WHERE course_id = $courseId'
        ' AND student_id = $studentId');
    CourseOrderList list = CourseOrderList.fromJson(data);
    await close();
    if (list.list != null && list.list!.isNotEmpty) {
      return list.list![0];
    }
    return null;
  }

  /*
  * 取得某課程所有選課資料
  * courseId: 課程id
  * status: 是否篩選狀態，-1代表不篩選
  * */
  Future<List<CourseOrder>?> getAllByCourse(int courseId, {int status = -1}) async {
    await initial();
    String sql = 'SELECT * FROM ${SqlConfig.dbCourseOrder} WHERE course_id = $courseId';
    if (status != -1) {
      sql += ' AND status = $status';
    }
    List<Map> data = await db.rawQuery(sql);
    CourseOrderList list = CourseOrderList.fromJson(data);
    await close();
    return list.list;
  }

  /*
  * 取得某學生所有選課資料
  * studentId: 學生id
  * status: 是否篩選狀態，-1代表不篩選
  * */
  Future<List<CourseOrder>?> getAllByStudent(int studentId, {int status = -1}) async {
    await initial();
    String sql = 'SELECT * FROM ${SqlConfig.dbCourseOrder} WHERE student_id = $studentId';
    if (status != -1) {
      sql += ' AND status = $status';
    }
    List<Map> data = await db.rawQuery(sql);
    CourseOrderList list = CourseOrderList.fromJson(data);
    await close();
    return list.list;
  }

  /*
  * 檢查某學生是否重複選課
  * studentId: 學生id
  * courseId: 課程id
  * 回傳true代表重複 false代表沒重複
  * */
  Future<bool> checkRepeat(int studentId, int courseId) async {
    List<CourseOrder>? dataAll = await getAllByStudent(studentId, status: 1);
    bool isRepeat = false;
    if (dataAll != null) {
      for (var element in dataAll) {
        if (element.courseId == courseId) {
          isRepeat = true;
          break;
        }
      }
    }
    return isRepeat;
  }

  /*
  * 檢查某學生選的課程時間是否與其他選的課程重疊
  * studentId: 學生id
  * week: 星期幾
  * startTime: 開始時間(15:00)
  * endTime: 結束時間(17:00)
  * filterCourseId: 要過濾掉不用判斷的課程id
  * 回傳0代表沒有重疊，其餘則回傳重疊的課程id
  * */
  Future<int> checkTimeOverlap(int studentId, int week, String startTime, String endTime, {int? filterCourseId}) async {
    List<CourseOrder>? dataAll = await getAllByStudent(studentId, status: 1);
    int overlapCourse = 0;
    if (dataAll != null) {
      CourseService courseService = CourseService();
      for (var element in dataAll) {
        Course? course = await courseService.get(element.courseId!);
        if (week != course?.week || (filterCourseId != null && filterCourseId == element.courseId!)) {
          //略過不同星期及指定過濾課程
          continue;
        }
        DateTime start = DateTime.parse("2024-01-01 $startTime");   //日期不重要
        DateTime end = DateTime.parse("2024-01-01 $endTime");
        DateTime currentStart = DateTime.parse("2024-01-01 ${course?.start}");
        DateTime currentEnd = DateTime.parse("2024-01-01 ${course?.end}");
        if (!(end.isBefore(currentStart) || start.isAfter(currentEnd))) {
          overlapCourse = element.courseId!;
          break;
        }
      }
    }
    return overlapCourse;
  }

  /*
  * 更新某筆資料
  * id
  * status: 狀態，1:成功選課 0:退選(預設成功選課)
  * */
  update(int id, {int status = 1}) async {
    await initial();
    await db.update(
        SqlConfig.dbCourseOrder,
        {
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
      id = await txn.rawDelete(
          'DELETE FROM ${SqlConfig.dbCourseOrder} WHERE id = ?', [id]
      );
    });
    await close();
  }

  /*
  * 移除資料
  * courseId: 課程id
  * */
  deleteByCourse(int courseId) async {
    await initial();
    await db.transaction((txn) async {
      await txn.delete(
        SqlConfig.dbCourseOrder,
        where: 'course_id = ?',
        whereArgs: [courseId]
      );
    });
    await close();
  }
}