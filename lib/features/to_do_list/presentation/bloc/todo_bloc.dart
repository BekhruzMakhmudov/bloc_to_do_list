import '../../domain/entities/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/usecases.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final DeleteTodo deleteTodo;
  bool showHistory = false;
  Category category = Category.all;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
    required this.deleteTodo,
  }) : super(TodoLoading()) {
    on<GetTodosEvent>(_onGetTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  Future<void> _onGetTodos(GetTodosEvent event, Emitter<TodoState> emit) async {
    try {
      final todos = await getTodos.execute();
      showHistory = event.showHistory;
      category = event.category;
      final sortedTodos = _sortTodosByPriority(todos);
      emit(
        TodosLoaded(
          todos: sortedTodos,
          showHistory: showHistory,
          category: category,
        ),
      );
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await addTodo.execute(event.todo);
      final todos = await getTodos.execute();
      final sortedTodos = _sortTodosByPriority(todos);
      emit(
        TodosLoaded(
          todos: sortedTodos,
          showHistory: showHistory,
          category: category,
        ),
      );
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _onDeleteTodo(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await deleteTodo.execute(event.id);
      final todos = await getTodos.execute();
      emit(
        TodosLoaded(
          todos: todos,
          showHistory: showHistory,
          category: category,
        ),
      );
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
