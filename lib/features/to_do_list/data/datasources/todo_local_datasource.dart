import 'package:hive/hive.dart';

import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> addTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final Box<TodoModel> todoBox;

  TodoLocalDataSourceImpl({required this.todoBox});

  @override
  Future<List<TodoModel>> getTodos() async {
    return todoBox.values.toList();
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    await todoBox.put(todo.id, todo);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await todoBox.delete(id);
  }
}