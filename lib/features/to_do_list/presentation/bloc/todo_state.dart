part of 'todo_bloc.dart';

enum TodoFilter { all, active, completed }

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodosLoaded extends TodoState {
  final List<Todo> todos;
  final TodoFilter filter;

  TodosLoaded({required this.todos, this.filter = TodoFilter.all});

  List<Todo> get filteredTodos {
    switch (filter) {
      case TodoFilter.active:
        return todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.completed:
        return todos.where((todo) => todo.isCompleted).toList();
      case TodoFilter.all:
        return todos;
    }
  }
}

class TodoLoaded extends TodoState {
  final Todo todo;

  TodoLoaded({required this.todo});
}

class TodoError extends TodoState {
  final String message;

  TodoError({required this.message});
}
