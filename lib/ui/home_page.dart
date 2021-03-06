import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_todo_getx/controllers/task_controller.dart';
import 'package:flutter_todo_getx/services/notification_service.dart';
import 'package:flutter_todo_getx/services/theme_service.dart';
import 'package:flutter_todo_getx/ui/add_task_bar.dart';
import 'package:flutter_todo_getx/ui/theme.dart';
import 'package:flutter_todo_getx/widgets/button.dart';
import 'package:flutter_todo_getx/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../model /task.dart';
import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                  context, _taskController.taskList[index]);
                            },
                            child: TaskTile(_taskController.taskList[index]))
                      ],
                    ),
                  ),
                ));
          });
    }));
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task Completed",
                  clr: primaryClr,
                  onTap: () {
                    Get.back();
                  },
                  context: context,
                ),
          _bottomSheetButton(
              context: context,
              label: "Delete task",
              clr: Colors.red[300]!,
              onTap: () {
                _taskController.delete(task);
                _taskController.getTask();
                Get.back();
              }),
          SizedBox(
            height: 20,
          ),
          _bottomSheetButton(
              context: context,
              label: "Close",
              isClose: true,
              clr: Colors.red[300]!,
              onTap: () {
                Get.back();
              }),
          SizedBox(
            height: 10,
          )
        ],
      ),
    ));
  }

  _bottomSheetButton(
      {required String label,
      required Color clr,
      bool isClose = false,
      required BuildContext context,
      required Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: isClose == true
                    ? Get.isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[300]!
                    : clr),
            borderRadius: BorderRadius.circular(20),
            color: isClose == true ? Colors.transparent : clr),
        child: Center(
            child: Text(label,
                style: isClose?titleStyle
                    : titleStyle.copyWith(color: Colors.white))),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 80,
        height: 100,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: headingStyle,
                ),
              ],
            ),
          ),
          MyButton(
              label: " + Add Task",
              onTap: () async {
                await Get.to(AddTaskPage());
                _taskController.getTask();
              })
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.requestIOSPermissions();
          notifyHelper.displayNotification(
              title: "ThemeChanged",
              body: Get.isDarkMode ? " lightMode" : "darkMode");
          notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile_img.jpeg"),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}
