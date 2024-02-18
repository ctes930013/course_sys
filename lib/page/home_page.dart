import 'package:course_sys/constants/Constants.dart';
import 'package:course_sys/route/router.dart';
import 'package:flutter/material.dart';

/*
* 首頁
*
* */
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Application.router.navigateTo(context,
                  "${Routers.login}?type=${Constants.teacher}",);
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Container(
                  width: 80,
                  height: 40,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: const Text(
                    "老師登入",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8,),
            GestureDetector(
              onTap: () {
                Application.router.navigateTo(context,
                  "${Routers.login}?type=${Constants.student}",);
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Container(
                  width: 80,
                  height: 40,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: const Text(
                    "學生登入",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
