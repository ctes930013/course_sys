import 'package:flutter/material.dart';

/*
* 共用的頂部app bar
* title: 標題
* rightWidget: 右側元件
* */
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? rightWidget;

  const CommonAppBar({
    super.key,
    required this.title,
    this.rightWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(
          color: Colors.black
      ),
      title: Text(title),
      centerTitle: true,
      //右側元件
      actions: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 10),
          child: (rightWidget != null) ? rightWidget : const SizedBox(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
