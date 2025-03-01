import '../entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> getTodoById(String id);
  Future<void> addTodo(Todo todo);
  Future<void> deleteTodo(String id);
}