import 'package:bloc_to_do_list/features/to_do_list/domain/entities/category.dart';
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
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: _buildBody(),
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

_buildAppBar(BuildContext context) {
  return AppBar(
    title: Text(
      'Todo List',
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.white,
          ),
    ),
    actions: [
      BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodosLoaded) {
            return IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                context.read<TodoBloc>().add(
                      GetTodosEvent(
                        showHistory: !state.showHistory,
                        category: state.category,
                      ),
                    );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ],
  );
}

Widget _buildDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        Container(
          height: MediaQuery.of(context).padding.top,
          color: Colors.deepPurple,
        ),
        ListTile(
          title: Text(
            'Category',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
          tileColor: Colors.deepPurple,
        ),
        Expanded(
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodosLoaded) {
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: Category.values.length,
                  itemBuilder: (context, index) {
                    final isSelected = state.category == Category.values[index];
                    return _buildDrawerItem(
                      context: context,
                      isSelected: isSelected,
                      category: Category.values[index],
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0),
                );
              } else if (state is TodoLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TodoError) {
                return Center(
                  child: Text('Error: ${state.message}'),
                );
              } else {
                return const Center(
                  child: Text('No todos available'),
                );
              }
            },
          ),
        ),
      ],
    ),
  );
}

_buildDrawerItem({
  required BuildContext context,
  required bool isSelected,
  required Category category,
}) {
  return ListTile(
    title: Text(category.name),
    leading: Icon(category.icon),
    selected: isSelected,
    selectedColor: Colors.deepPurple,
    onTap: () {
      context.read<TodoBloc>().add(GetTodosEvent(category: category));
      Navigator.of(context).pop();
    },
  );
}

_buildBody() {
  return BlocBuilder<TodoBloc, TodoState>(
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
                      'Category: ${state.category.name.toUpperCase()}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                        '${state.showHistory ? 'completed' : 'active'}: ${filteredTodos.length}'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: filteredTodos.isEmpty
                  ? Center(
                      child: Text(
                          'No ${state.showHistory ? 'completed' : 'active'} todos found.'),
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
  );
}
