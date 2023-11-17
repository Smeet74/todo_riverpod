import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rapidd_assignment/data/todo_services.dart';
import 'package:rapidd_assignment/view/bottom_screen.dart';
import 'view/signin_screen.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? user = FirebaseAuth.instance.currentUser;

  List todoList = box.read('todoList') ?? [];
  List list = todoList.isEmpty
      ? [
          {"name": "Task 1", "completed": true},
          {"name": "Task 2", "completed": false},
          {"name": "Task 3", "completed": true},
          {"name": "Task 4", "completed": false}
        ]
      : todoList;
  box.write('todoList', list);
  runApp(MainApp(user: user));
}

class MainApp extends StatelessWidget {
  final User? user;

  MainApp({this.user});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      // providers: [ChangeNotifierProvider(create: (_) => TodoViewModel())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: user == null ? SignInScreen() : BottomScreen(user: user!)),
    );
  }
}
