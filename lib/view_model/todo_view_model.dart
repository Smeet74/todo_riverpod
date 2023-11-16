import 'package:flutter/material.dart';

import '../data/todo_services.dart';
import '../model/todo.dart';

class TodoViewModel extends ChangeNotifier {
  bool _loading = false;
  List<TodoModel> _todoListModel = [];

  bool get loading => _loading;
  List<TodoModel> get todoListModel => _todoListModel;

  TodoViewModel() {
    getTodoList();
  }
  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setTodoListModel(List<TodoModel> todoListModel) {
    _todoListModel = todoListModel;
  }

  updateDataToLocal() {
    box.write("todoList", _todoListModel);
  }

  getTodoList() async {
    setLoading(true);
    var todoData = await TodoServices().getTodoList();
    setTodoListModel(todoData as List<TodoModel>);
    setLoading(false);
  }

  addItem(TodoModel todoItem) {
    setLoading(true);
    _todoListModel.add(todoItem);
    setLoading(false);
    updateDataToLocal();
  }

  deleteItem(int index) {
    setLoading(true);
    _todoListModel.removeAt(index);
    setLoading(false);
    updateDataToLocal();
  }

  updateItem(int index, TodoModel todoItem) {
    setLoading(true);
    _todoListModel[index] = todoItem;
    setLoading(false);
    updateDataToLocal();
  }
}
