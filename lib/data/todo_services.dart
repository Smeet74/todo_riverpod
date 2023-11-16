import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:rapidd_assignment/model/todo.dart';
import 'package:http/http.dart' as http;

final box = GetStorage();

class TodoServices {
  getTodoList() async {
    List todoListModel = box.read('todoList') ?? [];
    // var response =
    //     await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    // print("response is ${response.body}");
    // print("response is ${response.body.runtimeType}");

    return todoListModelFromJson(jsonEncode(todoListModel));
  }
}
