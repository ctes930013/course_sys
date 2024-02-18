import 'package:course_sys/database/base_db.dart';
import 'package:course_sys/database/sql_config.dart';
import 'package:course_sys/model/teacher.dart';

/*
* 存取老師資料表相關類
*
* */
class TeacherService extends BaseDb {

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
  * desc: 簡介
  * */
  Future<int> insert(String account, String password, String name, String desc) async {
    await initial();
    int id = 0;
    await db.transaction((txn) async {
      id = await txn.rawInsert(
          'INSERT INTO ${SqlConfig.dbTeacher} '
              '(account, password, name, desc) VALUES '
              '("$account", "$password", "$name", "$desc")'
      );
    });
    await close();
    return id;
  }

  /*
  * 取得所有資料
  *
  * */
  Future<List<Teacher>?> getAll() async {
    await initial();
    List<Map> data = await db.rawQuery('SELECT * FROM ${SqlConfig.dbTeacher}');
    TeacherList list = TeacherList.fromJson(data);
    await close();
    return list.list;
  }

  /*
  * 取得某筆資料
  * id
  * */
  Future<Teacher?> get(int id) async {
    await initial();
    List<Map> data = await db.rawQuery('SELECT * FROM ${SqlConfig.dbTeacher} WHERE id = $id');
    TeacherList list = TeacherList.fromJson(data);
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
  Future<Teacher?> getByAccount(String account) async {
    await initial();
    List<Map> data = await db.rawQuery('SELECT * FROM ${SqlConfig.dbTeacher} WHERE account = ?',
        [account]);
    TeacherList list = TeacherList.fromJson(data);
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
  Future<Teacher?> verify(String account, String password) async {
    await initial();
    List<Map> data = await db.rawQuery('SELECT * FROM ${SqlConfig.dbTeacher} WHERE account = ? AND password = ?',
        [account, password]);
    TeacherList list = TeacherList.fromJson(data);
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
    Teacher? data = await getByAccount(account);
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
      SqlConfig.dbTeacher,
      {
        'password': password,
      },
      where: 'id = ?',
      whereArgs: [id]
    );
    await close();
  }

  /*
  * 更新某筆資料的名稱及簡介
  * id
  * name: 名稱
  * desc: 簡介
  * */
  updateNameAndDesc(int id, String name, String desc) async {
    await initial();
    await db.update(
        SqlConfig.dbTeacher,
        {
          'name': name,
          'desc': desc,
        },
        where: 'id = ?',
        whereArgs: [id]
    );
    await close();
  }
}