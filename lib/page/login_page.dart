import 'package:course_sys/constants/Constants.dart';
import 'package:course_sys/route/router.dart';
import 'package:course_sys/utils/keyboard_hide_widget.dart';
import 'package:course_sys/viewmodel/login_view_model.dart';
import 'package:course_sys/widget/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
* 登入頁
* type: 身分
* */
class LoginPage extends StatefulWidget {
  final String type;
  const LoginPage({super.key, required this.type,});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late LoginViewModel _loginViewModel;

  @override
  void initState() {
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    _loginViewModel.init(context, widget.type);
    super.initState();
  }

  @override
  void dispose() {
    accountController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: widget.type == Constants.teacher ? "老師登入" : "學生登入"),
      body: KeyboardHideWidget(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: accountController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: "帳號",
                ),
              ),
              const SizedBox(height: 4,),
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: "密碼",
                ),
              ),
              const SizedBox(height: 8,),
              GestureDetector(
                onTap: () {
                  _loginViewModel.login(accountController.text, passwordController.text);
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    width: 80,
                    height: 40,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const Text(
                      "登入",
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
                    "${Routers.signup}?type=${widget.type}",);
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    width: 80,
                    height: 40,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const Text(
                      "註冊",
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
      ),
    );
  }
}
