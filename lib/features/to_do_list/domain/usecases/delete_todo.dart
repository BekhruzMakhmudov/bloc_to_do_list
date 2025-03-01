import '../repositories/todo_repository.dart';

class DeleteTodo {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  Future<void> execute(String id) {
    return repository.deleteTodo(id);
  }
}