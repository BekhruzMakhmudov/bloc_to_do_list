part of 'todo_bloc.dart';

abstract class TodoEvent {}

class GetTodosEvent extends TodoEvent {
  final bool showHistory;
  final Category category;

  GetTodosEvent({
    this.showHistory = false,
    this.category = Category.all,
  });
}

class AddTodoEvent extends TodoEvent {
  final Todo todo;

  AddTodoEvent({required this.todo});
}

class DeleteTodoEvent extends TodoEvent {
  final String id;

  DeleteTodoEvent({required this.id});
}
