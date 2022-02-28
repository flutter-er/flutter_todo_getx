import 'package:flutter_todo_getx/db/db_helper.dart';
import 'package:get/get.dart';

import '../model /task.dart';

class TaskController extends GetxController{

  @override
  void onReady() {
    super.onReady();
  }

  Future<int> addTask({Task? task}) async{
    return await  DBHelper.insert(task);
  }

}