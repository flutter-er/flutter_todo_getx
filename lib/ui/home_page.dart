import 'package:flutter/material.dart';
import 'package:flutter_todo_getx/services/notification_service.dart';
import 'package:flutter_todo_getx/services/theme_service.dart';
import 'package:flutter_todo_getx/ui/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat.yMMMMd().format(DateTime.now()), style: subHeadingStyle ,),
                    Text('Today', style: headingStyle,),

                  ],
                ),
              )
            ],
          )
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
