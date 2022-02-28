import 'package:flutter/material.dart';
import 'package:flutter_todo_getx/db/db_helper.dart';
import 'package:flutter_todo_getx/services/theme_service.dart';
import 'package:flutter_todo_getx/ui/home_page.dart';
import 'package:flutter_todo_getx/ui/theme.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: ThemeService().theme,
      home: HomePage()
    );
  }
}
