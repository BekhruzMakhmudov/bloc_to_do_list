part of 'todo_bloc.dart';

abstract class TodoEvent {}

class GetTodosEvent extends TodoEvent {
  final TodoFilter filter;

  GetTodosEvent({this.filter = TodoFilter.all});
}

class GetTodoByIdEvent extends TodoEvent {
  final String id;

  GetTodoByIdEvent({required this.id});
}

class AddTodoEvent extends TodoEvent {
  final Todo todo;

  AddTodoEvent({required this.todo});
}

class DeleteTodoEvent extends TodoEvent {
  final String id;

  DeleteTodoEvent({required this.id});
}

class ToggleTodoEvent extends TodoEvent {
  final Todo todo;

  ToggleTodoEvent({required this.todo});
}

class ChangeFilterEvent extends TodoEvent {
  final TodoFilter filter;

  ChangeFilterEvent({required this.filter});
}
