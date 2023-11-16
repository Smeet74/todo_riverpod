import 'package:flutter/material.dart';
import 'package:rapidd_assignment/view_model/todo_view_model.dart';
import 'package:provider/provider.dart';

import '../model/todo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    TodoViewModel todoViewModel = context.watch<TodoViewModel>();
    print("length is ${todoViewModel.todoListModel.length}");

    itemDialog() {
      return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Item'),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: 'Enter value'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, textController.text),
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Simple Todo App"),),
      body: Container(
        child: todoViewModel.loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                itemCount: todoViewModel.todoListModel.length,
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemBuilder: (context, index) {
                  TodoModel todoItem = todoViewModel.todoListModel[index];
                  print("todoItem is $todoItem");
                  return Row(
                    children: [
                      Checkbox(
                          value: todoItem.completed,
                          onChanged: (_) {
                            todoViewModel.updateItem(
                                index,
                                TodoModel(
                                    name: todoItem.name.toString(),
                                    completed: !todoItem.completed));
                          }),
                      Spacer(),
                      Expanded(
                        child: Text(
                          todoItem.name.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            final result = await itemDialog();
                            if (result != null && result.isNotEmpty) {
                              todoViewModel.updateItem(
                                  index,
                                  TodoModel(
                                      name: textController.text,
                                      completed: false));
                            }
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Colors.black,
                          )),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            todoViewModel.deleteItem(index);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                    ],
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await itemDialog();
          if (result != null && result.isNotEmpty) {
            todoViewModel.addItem(
                TodoModel(name: textController.text, completed: false));
            // ref.read(itemsProvider.notifier).addItem(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
