import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Todo>> getTodos() async {
    final todoModels = await localDataSource.getTodos();
    return todoModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Todo> getTodoById(String id) async {
    final todoModel = await localDataSource.getTodoById(id);
    return todoModel.toEntity();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final todoModel = TodoModel.fromEntity(todo);
    await localDataSource.addTodo(todoModel);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await localDataSource.deleteTodo(id);
  }
}