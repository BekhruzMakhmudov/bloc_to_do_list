import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/usecases.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final GetTodoById getTodoById;
  final AddTodo addTodo;
  final DeleteTodo deleteTodo;
  TodoFilter _currentFilter = TodoFilter.all;

  TodoBloc({
    required this.getTodos,
    required this.getTodoById,
    required this.addTodo,
    required this.deleteTodo,
  }) : super(TodoInitial()) {
    on<GetTodosEvent>(_onGetTodos);
    on<GetTodoByIdEvent>(_onGetTodoById);
    on<AddTodoEvent>(_onAddTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
    on<ChangeFilterEvent>(_onChangeFilter);
  }

  Future<void> _onGetTodos(GetTodosEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await getTodos.execute();
      _currentFilter = event.filter;
      final sortedTodos = _sortTodosByPriority(todos);
      emit(TodosLoaded(todos: sortedTodos, filter: _currentFilter));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _onGetTodoById(
      GetTodoByIdEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todo = await getTodoById.execute(event.id);
      emit(TodoLoaded(todo: todo));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await addTodo.execute(event.todo);
      final todos = await getTodos.execute();
      final sortedTodos = _sortTodosByPriority(todos);
      emit(TodosLoaded(todos: sortedTodos, filter: _currentFilter));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _onDeleteTodo(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await deleteTodo.execute(event.id);
      final todos = await getTodos.execute();
      emit(TodosLoaded(todos: todos, filter: _currentFilter));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _onToggleTodo(
      ToggleTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final updatedTodo = event.todo.copyWith(
        isCompleted: !event.todo.isCompleted,
      );
      await addTodo.execute(updatedTodo);
      final todos = await getTodos.execute();
      final sortedTodos = _sortTodosByPriority(todos);
      emit(TodosLoaded(todos: sortedTodos, filter: _currentFilter));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _onChangeFilter(
      ChangeFilterEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await getTodos.execute();
      _currentFilter = event.filter;
      final sortedTodos = _sortTodosByPriority(todos);
      emit(TodosLoaded(todos: sortedTodos, filter: _currentFilter));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  List<Todo> _sortTodosByPriority(List<Todo> todos) {
    final sortedTodos = List<Todo>.from(todos);
    sortedTodos.sort((a, b) {
      final priorityComparison = b.priority.index.compareTo(a.priority.index);
      if (priorityComparison != 0) {
        return priorityComparison;
      }
      return b.createdAt.compareTo(a.createdAt);
    });
    return sortedTodos;
  }
}
