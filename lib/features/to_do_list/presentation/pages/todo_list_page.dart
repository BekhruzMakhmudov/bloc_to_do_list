import 'package:bloc_to_do_list/features/to_do_list/presentation/widgets/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_bloc.dart';
import 'add_todo_page.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodosLoaded) {
                return IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: 'Toggle filter',
                  onPressed: () {
                    TodoFilter nextFilter;
                    switch (state.filter) {
                      case TodoFilter.all:
                        nextFilter = TodoFilter.active;
                        break;
                      case TodoFilter.active:
                        nextFilter = TodoFilter.completed;
                        break;
                      case TodoFilter.completed:
                        nextFilter = TodoFilter.all;
                        break;
                    }
                    context.read<TodoBloc>().add(
                          ChangeFilterEvent(filter: nextFilter),
                        );
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Showing ${nextFilter.name} todos'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TodosLoaded) {
            final filteredTodos = state.filteredTodos;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter: ${state.filter.name.toUpperCase()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${filteredTodos.length} todos'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: filteredTodos.isEmpty
                      ? Center(
                          child: Text('No ${state.filter.name} todos found.'),
                        )
                      : ListView.builder(
                          itemCount: filteredTodos.length,
                          itemBuilder: (context, index) {
                            final todo = filteredTodos[index];
                            return Dismissible(
                              key: Key(todo.id),
                              onDismissed: (direction) {
                                final deletedTodo = todo;
                                context.read<TodoBloc>().add(
                                      DeleteTodoEvent(id: todo.id),
                                    );
                                if (direction == DismissDirection.startToEnd) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AddTodoPage(todo: deletedTodo),
                                    ),
                                  );
                                }
                              },
                              background: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              secondaryBackground: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              child: ToDoItem(toDo: todo),
                            );
                          },
                        ),
                ),
              ],
            );
          } else if (state is TodoError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddTodoPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension TodoFilterExtension on TodoFilter {
  String get name {
    switch (this) {
      case TodoFilter.all:
        return 'all';
      case TodoFilter.active:
        return 'active';
      case TodoFilter.completed:
        return 'completed';
    }
  }
}
