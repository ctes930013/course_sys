import 'package:flutter/material.dart';

/*
* 點擊外處自動收起鍵盤元件
* child: 子元件
* */
class KeyboardHideWidget extends StatelessWidget {
  final Widget child;

  const KeyboardHideWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 触摸收起键盘
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: child,
    );
  }
}
