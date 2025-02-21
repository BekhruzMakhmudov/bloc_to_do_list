import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/to_do_item.dart';

part 'to_do_list_event.dart';
part 'to_do_list_state.dart';

class ToDoListBloc extends Bloc<ToDoListEvent, ToDoListState> {
  ToDoListBloc() : super(ToDoListLoadedState(activeTasks: [], historyTasks: [], showHistory: false)) {
    on<AddToDoEvent>((event, emit) {
      final currentState = state as ToDoListLoadedState;
      emit(ToDoListLoadedState(
        activeTasks: [...currentState.activeTasks, event.toDoItem],
        historyTasks: currentState.historyTasks,
        showHistory: currentState.showHistory,
      ));
    });

    on<CompleteToDoEvent>((event, emit) {
      final currentState = state as ToDoListLoadedState;
      emit(ToDoListLoadedState(
        activeTasks: currentState.activeTasks.where((task) => task.id != event.toDoItem.id).toList(),
        historyTasks: [...currentState.historyTasks, event.toDoItem],
        showHistory: currentState.showHistory,
      ));
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
}