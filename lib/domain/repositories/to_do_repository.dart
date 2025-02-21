import '../entities/to_do_item.dart';

abstract class ToDoRepository {
  Future<void> addToDo(ToDoItem toDoItem);
}
