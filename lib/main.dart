import 'package:course_sys/constants/Constants.dart';
import 'package:course_sys/database/base_db.dart';
import 'package:course_sys/route/router.dart';
import 'package:course_sys/viewmodel/teacher_list_view_model.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharePref;
Future<void> main() async {
  await init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TeacherListViewModel>(
            create: (context) => TeacherListViewModel()),
      ],
      child: const MyApp(),
    )
  );
}

/*
* 初始化資料庫及偏好
*
* */
Future<void> init() async {
  BaseDb baseDb = BaseDb();
  WidgetsFlutterBinding.ensureInitialized();
  await baseDb.init();
  await baseDb.close();
  sharePref = await SharedPreferences.getInstance();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //初始化路由管理
    final router = FluroRouter();
    Application.router = router;
    Routers.configureRoutes(router);
    SystemChrome.setPreferredOrientations([
      //固定直立
      DeviceOrientation.portraitUp,
    ]);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: !checkIsLogin() ? Routers.root : Routers.teacherList,
      onGenerateRoute: Application.router.generator,
    );
  }

  /*
  * 檢查當前有無登入
  *
  * */
  bool checkIsLogin() {
    bool isLogin = sharePref.containsKey(Constants.userIdKey);
    if (isLogin) {
      Constants.userId = sharePref.getInt(Constants.userIdKey);
      Constants.userName = sharePref.getString(Constants.userNameKey);
      Constants.userType = sharePref.getString(Constants.userTypeKey);
    }
    return isLogin;
  }
}