import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:rapidd_assignment/data/todo_services.dart';
import 'package:rapidd_assignment/view_model/todo_view_model.dart';

import 'view/home_screen.dart';

void main() async {
  await GetStorage.init();
  List todoList = box.read('todoList') ?? [];
  List list = todoList.isEmpty
      ? [
          {"name": "Task 1", "completed": true},
          {"name": "Task 2", "completed": false},
          {"name": "Task 3", "completed": false},
          {"name": "Task 4", "completed": false}
        ]
      : todoList;
  box.write('todoList', list);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TodoViewModel())],
      child: MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
    );
  }
}
