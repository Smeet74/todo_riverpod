import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapidd_assignment/view_model/todo_view_model.dart';

import '../model/todo.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();
    final todoState = ref.watch(todoViewModelProvider);
    final isLoading = todoState.loading;
    final todoList = todoState.todoList;

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
      appBar: AppBar(
        title: Text("Simple Todo App"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                itemCount: todoList.length,
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemBuilder: (context, index) {
                  TodoModel todoItem = todoList[index];
                  print("todoItem is $todoItem");
                  return Row(
                    children: [
                      Checkbox(
                          value: todoItem.completed,
                          onChanged: (_) {
                            ref.read(todoViewModelProvider.notifier).updateItem(
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
                              ref
                                  .read(todoViewModelProvider.notifier)
                                  .updateItem(
                                      index,
                                      TodoModel(
                                          name: textController.text,
                                          completed: todoItem.completed));
                            }
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Colors.black,
                          )),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            ref
                                .read(todoViewModelProvider.notifier)
                                .deleteItem(index);
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
            ref.read(todoViewModelProvider.notifier).addItem(
                TodoModel(name: textController.text, completed: false));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
