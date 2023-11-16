import 'dart:convert';

List<TodoModel> todoListModelFromJson(String str) => List<TodoModel>.from(json.decode(str).map((x) => TodoModel.fromJson(x)));

String todoListModelToJson(List<TodoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class TodoModel {
    String name;
    bool completed;

    TodoModel({
        required this.name,
        required this.completed,
    });

    

    factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        name: json["name"],
        completed: json["completed"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "completed": completed,
    };
}
