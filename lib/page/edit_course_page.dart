import 'package:course_sys/constants/Constants.dart';
import 'package:course_sys/route/router.dart';
import 'package:course_sys/utils/keyboard_hide_widget.dart';
import 'package:course_sys/viewmodel/edit_course_view_model.dart';
import 'package:course_sys/widget/common_app_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
* 編輯課程頁
* courseId: 課程id(為0代表是新增課程)
* */
class EditCoursePage extends StatefulWidget {
  final int courseId;
  const EditCoursePage({super.key, required this.courseId,});

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {

  late EditCourseViewModel _editCourseViewModel;

  @override
  void initState() {
    _editCourseViewModel = Provider.of<EditCourseViewModel>(context, listen: false);
    _editCourseViewModel.init(context);
    if (widget.courseId != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _editCourseViewModel.getCourseData(widget.courseId);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "新增編輯課程",
        rightWidget: widget.courseId == 0 ? const SizedBox() : InkWell(
          onTap: () {
            showDeleteDialog();
          },
          child: const Icon(
              Icons.delete,
              size: 20,
              color: Colors.black87
          ),
        ),
      ),
      body: KeyboardHideWidget(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _editCourseViewModel.nameController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: "課程名稱(必填)",
                ),
              ),
              const SizedBox(height: 4,),
              TextField(
                controller: _editCourseViewModel.descController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "課程介紹",
                ),
              ),
              const SizedBox(height: 4,),
              //星期幾
              Row(
                children: [
                  const Text(
                    "開課時間",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Selector<EditCourseViewModel, int>(
                      selector: (_, model) => model.selectedWeekIndex,
                      builder: (_, data, __) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            items: _editCourseViewModel.weekItems.map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )).toList(),
                            value: _editCourseViewModel.weekItems[_editCourseViewModel.selectedWeekIndex],
                            onChanged: (String? value) {
                              _editCourseViewModel.setSelectedWeek(value ?? "");
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8,),
                  const Text(
                    "狀態",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  //狀態開關
                  Selector<EditCourseViewModel, bool>(
                    selector: (_, model) => model.isEnabled,
                    builder: (_, data, __) {
                      return Switch(
                        value: data,
                        onChanged: (value) {
                          _editCourseViewModel.setStatus(value);
                        },
                      );
                  }),
                ],
              ),
              const SizedBox(height: 4,),
              //幾點
              Row(
                children: [
                  const Text(
                    "開課時段",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Selector<EditCourseViewModel, String>(
                      selector: (_, model) => model.selectedStartTime,
                      builder: (_, data, __) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            items: _editCourseViewModel.startTimeItems.map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )).toList(),
                            value: _editCourseViewModel.selectedStartTime,
                            onChanged: (String? value) {
                              _editCourseViewModel.setSelectedStartTime(value ?? "");
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Text(
                    "~",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Selector<EditCourseViewModel, String>(
                      selector: (_, model) => model.selectedEndTime,
                      builder: (_, data, __) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            items: _editCourseViewModel.endTimeItems.map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )).toList(),
                            value: _editCourseViewModel.selectedEndTime,
                            onChanged: (String? value) {
                              _editCourseViewModel.setSelectedEndTime(value ?? "");
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8,),
              GestureDetector(
                onTap: () {
                  _editCourseViewModel.addCourse(Constants.userId!, widget.courseId);
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    width: 80,
                    height: 40,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const Text(
                      "送出",
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

  /*
  * 確認是否刪除課程彈窗
  * */
  showDeleteDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('移除課程'),
        content: const Text('確定刪除開課程嗎? 刪除後將無法再還原'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _editCourseViewModel.deleteCourse(widget.courseId);
              if (mounted) {
                Application.router.navigateTo(context,
                    Routers.teacherList, clearStack: true);
              }
            },
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }
}
