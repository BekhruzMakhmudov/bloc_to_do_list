import 'package:hive/hive.dart';

import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> getTodoById(String id);
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
  Future<TodoModel> getTodoById(String id) async {
    final todo = todoBox.get(id);
    if (todo == null) {
      throw Exception('Todo not found');
    }
    return todo;
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