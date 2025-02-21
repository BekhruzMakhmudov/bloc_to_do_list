part of 'to_do_list_bloc.dart';

abstract class ToDoListState {}

class ToDoListInitialState extends ToDoListState {}

class ToDoListLoadingState extends ToDoListState {}

class ToDoListLoadedState extends ToDoListState {
  final List<ToDoItem> activeTasks;
  final List<ToDoItem> historyTasks;
  final bool showHistory;

  ToDoListLoadedState({
    required this.activeTasks,
    required this.historyTasks,
    required this.showHistory,
  });

  List<ToDoItem> get displayedTasks => showHistory ? historyTasks : activeTasks;
}

class ToDoListErrorState extends ToDoListState {
  final String message;
  ToDoListErrorState(this.message);
}