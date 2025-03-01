import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class GetTodoById {
  final TodoRepository repository;

  GetTodoById(this.repository);

  Future<Todo> execute(String id) {
    return repository.getTodoById(id);
  }
}