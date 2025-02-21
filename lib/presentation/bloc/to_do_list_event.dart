part of 'to_do_list_bloc.dart';

abstract class ToDoListEvent {}

class AddToDoEvent extends ToDoListEvent {
  final ToDoItem toDoItem;
  AddToDoEvent(this.toDoItem);
}

class CompleteToDoEvent extends ToDoListEvent {
  final ToDoItem toDoItem;
  CompleteToDoEvent(this.toDoItem);
}

class ShowHistoryEvent extends ToDoListEvent {}
class ShowActiveEvent extends ToDoListEvent {}