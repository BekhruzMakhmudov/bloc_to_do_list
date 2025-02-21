import '../entities/to_do_item.dart';
import '../repositories/to_do_repository.dart';

class AddToDoUseCase {
  final ToDoRepository repository;

  AddToDoUseCase(this.repository);

  Future<void> call(ToDoItem toDoItem) async {
    return await repository.addToDo(toDoItem);
  }
}