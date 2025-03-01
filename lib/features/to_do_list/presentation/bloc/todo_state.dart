part of 'todo_bloc.dart';

abstract class TodoState {}

class TodoLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<Todo> todos;
  final bool showHistory;
  final Category category;

  TodosLoaded({
    required this.todos,
    required this.showHistory,
    required this.category
  });

  List<Todo> get filteredTodos {
    return (category==Category.all)
        ? todos.where((todo) => todo.isCompleted==showHistory).toList()
        : todos.where((todo) => todo.isCompleted==showHistory && todo.category==category).toList();
  }
}

class TodoError extends TodoState {
  final String message;

  TodoError({required this.message});
}
