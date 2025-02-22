import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../data/models/priority.dart';
import '../../domain/entities/to_do_item.dart';

part 'to_do_list_event.dart';
part 'to_do_list_state.dart';

class ToDoListBloc extends Bloc<ToDoListEvent, ToDoListState> {
  ToDoListBloc() : super(ToDoListLoadedState(activeTasks: [], historyTasks: [], showHistory: false)) {
    on<AddToDoEvent>((event, emit) async {
      final currentState = state as ToDoListLoadedState;
      final newActiveTasks = [...currentState.activeTasks, event.toDoItem];
      final sortedActiveTasks = _sortTasksByPriority(newActiveTasks);
      emit(ToDoListLoadedState(
        activeTasks: sortedActiveTasks,
        historyTasks: currentState.historyTasks,
        showHistory: currentState.showHistory,
      ));
      final toDoBox = await Hive.openBox<ToDoItem>('toDoItems');
      toDoBox.put(event.toDoItem.id, event.toDoItem);
    });

    on<CompleteToDoEvent>((event, emit) async {
      final currentState = state as ToDoListLoadedState;
      final newActiveTasks = currentState.activeTasks.where((task) => task.id != event.toDoItem.id).toList();
      final newHistoryTasks = [...currentState.historyTasks, event.toDoItem];
      final sortedActiveTasks = _sortTasksByPriority(newActiveTasks);
      final sortedHistoryTasks = _sortTasksByPriority(newHistoryTasks);
      emit(ToDoListLoadedState(
        activeTasks: sortedActiveTasks,
        historyTasks: sortedHistoryTasks,
        showHistory: currentState.showHistory,
      ));
      final toDoBox = await Hive.openBox<ToDoItem>('toDoItems');
      toDoBox.put(event.toDoItem.id, event.toDoItem.copyWith(isCompleted: true));
    });

    on<ShowHistoryEvent>((event, emit) {
      final currentState = state as ToDoListLoadedState;
      emit(ToDoListLoadedState(
        activeTasks: currentState.activeTasks,
        historyTasks: currentState.historyTasks,
        showHistory: true,
      ));
    });

    on<ShowActiveEvent>((event, emit) {
      final currentState = state as ToDoListLoadedState;
      emit(ToDoListLoadedState(
        activeTasks: currentState.activeTasks,
        historyTasks: currentState.historyTasks,
        showHistory: false,
      ));
    });
  }

  List<ToDoItem> _sortTasksByPriority(List<ToDoItem> tasks) {
    final sortedTasks = [...tasks]; // Create a copy to avoid modifying the original list
    sortedTasks.sort((a, b) {
      // Sort by priority (high to low)
      if (a.priority == Priority.high && b.priority != Priority.high) {
        return -1;
      } else if (a.priority != Priority.high && b.priority == Priority.high) {
        return 1;
      } else if (a.priority == Priority.medium && b.priority == Priority.low) {
        return -1;
      } else if (a.priority == Priority.low && b.priority == Priority.medium) {
        return 1;
      } else {
        return 0;
      }
    });
    return sortedTasks;
  }
}