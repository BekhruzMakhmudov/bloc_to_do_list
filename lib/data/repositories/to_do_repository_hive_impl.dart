import 'package:hive/hive.dart';
import '../../domain/entities/to_do_item.dart';
import '../../domain/repositories/to_do_repository.dart';

class ToDoRepositoryHiveImpl implements ToDoRepository {
  final Box _box;

  ToDoRepositoryHiveImpl(this._box);

  @override
  Future<void> addToDo(ToDoItem toDoItem) async {
    await _box.put(toDoItem.id, toDoItem);
  }
}