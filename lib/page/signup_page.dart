import 'package:course_sys/constants/Constants.dart';
import 'package:course_sys/utils/keyboard_hide_widget.dart';
import 'package:course_sys/viewmodel/login_view_model.dart';
import 'package:course_sys/widget/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
* 註冊頁
* type: 身分
* */
class SingupPage extends StatefulWidget {
  final String type;
  const SingupPage({super.key, required this.type,});

  @override
  State<SingupPage> createState() => _SingupPageState();
}

class _SingupPageState extends State<SingupPage> {

  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
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
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: widget.type == Constants.teacher ? "老師註冊" : "學生註冊"),
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
                  hintText: "帳號(必填)",
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
                  hintText: "密碼(必填)",
                ),
              ),
              const SizedBox(height: 4,),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: "姓名(必填)",
                ),
              ),
              const SizedBox(height: 4,),
              if (widget.type == Constants.teacher)
                TextField(
                  controller: descController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "自我介紹",
                  ),
                ),
                const SizedBox(height: 8,),
              GestureDetector(
                onTap: () {
                  _loginViewModel.signup(
                    accountController.text,
                    passwordController.text,
                    nameController.text,
                    desc: descController.text,
                  );
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
