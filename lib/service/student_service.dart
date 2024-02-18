import 'package:course_sys/database/base_db.dart';
import 'package:course_sys/database/sql_config.dart';
import 'package:course_sys/model/student.dart';

/*
* 存取學生資料表相關類
*
* */
class StudentService extends BaseDb {

  /*
  * 初始化
  * */
  initial() async {
    await super.init();
  }

  /*
  * 新增資料
  * account: 帳號
  * password: 密碼
  * name: 名稱
  * */
  Future<int> insert(String account, String password, String name) async {
    await initial();
    int id = 0;
    await db.transaction((txn) async {
      id = await txn.rawInsert(
          'INSERT INTO ${SqlConfig.dbStudent} '
              '(account, password, name) VALUES '
              '("$account", "$password", "$name")'
      );
    });
    await close();
    return id;
  }

  /*
  * 取得所有資料
  *
  * */
  Future<List<Student>?> getAll() async {
    await initial();
    List<Map> data = await db.rawQuery('SELECT * FROM ${SqlConfig.dbStudent}');
    StudentList list = StudentList.fromJson(data);
    await close();
    return list.list;
  }

  /*
  * 取得某筆資料
  * id
  * */
  Future<Student?> get(int id) async {
    await initial();
    List<Map> data = await db.rawQuery('SELECT * FROM ${SqlConfig.dbStudent} WHERE id = $id');
    StudentList list = StudentList.fromJson(data);
    await close();
    if (list.list != null && list.list!.isNotEmpty) {
      return list.list![0];
    }
    return null;
  }

  /*
  * 根據帳號取得某筆資料
  * account: 帳號
  * */
  Future<Student?> getByAccount(String account) async {
    await initial();
    List<Map> data = await db.rawQuery('SELECT * FROM ${SqlConfig.dbStudent} WHERE account = ?',
        [account]);
    StudentList list = StudentList.fromJson(data);
    await close();
    if (list.list != null && list.list!.isNotEmpty) {
      return list.list![0];
    }
    return null;
  }

  /*
  * 驗證帳密是否正確
  * account: 帳號
  * password: 密碼
  * */
  Future<Student?> verify(String account, String password) async {
    await initial();
    List<Map> data = await db.rawQuery('SELECT * FROM ${SqlConfig.dbStudent} WHERE account = ? AND password = ?',
        [account, password]);
    StudentList list = StudentList.fromJson(data);
    await close();
    if (list.list != null && list.list!.isNotEmpty) {
      return list.list![0];
    }
    return null;
  }

  /*
  * 檢查某帳號是否存在
  * account: 帳號
  * 回傳true代表存在 false代表不存在
  * */
  Future<bool> checkAccountExists(String account) async {
    Student? data = await getByAccount(account);
    return data != null;
  }

  /*
  * 更新某筆資料的密碼
  * id
  * password: 密碼
  * */
  updatePassword(int id, String password) async {
    await initial();
    await db.update(
        SqlConfig.dbStudent,
        {
          'password': password,
        },
        where: 'id = ?',
        whereArgs: [id]
    );
    await close();
  }

  /*
  * 更新某筆資料的名稱
  * id
  * name: 名稱
  * */
  updateName(int id, String name) async {
    await initial();
    await db.update(
        SqlConfig.dbStudent,
        {
          'name': name,
        },
        where: 'id = ?',
        whereArgs: [id]
    );
    await close();
  }
}