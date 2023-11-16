import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/todo_services.dart';
import '../model/todo.dart';

class TodoState {
  final bool loading;
  final List<TodoModel> todoList;

  TodoState({required this.loading, required this.todoList});
}

final todoViewModelProvider = StateNotifierProvider<TodoViewModel, TodoState>(
  (ref) => TodoViewModel(),
);

class TodoViewModel extends StateNotifier<TodoState> {
  TodoViewModel() : super(TodoState(loading: false, todoList: [])) {
    getTodoList();
  }

  bool _loading = false;
  List<TodoModel> _todoListModel = [];

  bool get loading => _loading;
  List<TodoModel> get todoListModel => _todoListModel;

  setLoading(bool isLoading) {
    state = TodoState(loading: isLoading, todoList: state.todoList);
  }

  setTodoListModel(List<TodoModel> todoListModel) {
    state = TodoState(loading: state.loading, todoList: todoListModel);
  }

  updateDataToLocal() {
    box.write("todoList", state.todoList);
  }

  getTodoList() async {
    setLoading(true);
    var todoData = await TodoServices().getTodoList();
    setTodoListModel(todoData as List<TodoModel>);
    setLoading(false);
  }

  addItem(TodoModel todoItem) {
    state = TodoState(loading: true, todoList: state.todoList);
    List<TodoModel> newList = List.from(state.todoList); // create a new list
    newList.add(todoItem); // modify the new list
    state = TodoState(
        loading: false,
        todoList: newList); // update the state with the new list
    updateDataToLocal();
  }

  deleteItem(int index) {
    state = TodoState(loading: true, todoList: state.todoList);
    List<TodoModel> newList = List.from(state.todoList);
    newList.removeAt(index);
    state = TodoState(loading: false, todoList: newList);
    updateDataToLocal();
  }

  updateItem(int index, TodoModel todoItem) {
    state = TodoState(loading: true, todoList: state.todoList);
    List<TodoModel> newList = List.from(state.todoList);
    newList[index] = todoItem;
    state = TodoState(loading: false, todoList: newList);
    updateDataToLocal();
  }
}
