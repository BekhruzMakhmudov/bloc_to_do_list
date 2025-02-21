import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/to_do_list_bloc.dart';
import '../widgets/to_do_item_widget.dart';
import 'add_to_do_item_screen.dart';

class ToDoListScreen extends StatelessWidget {
  const ToDoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              final bloc = context.read<ToDoListBloc>();
              final currentState = bloc.state as ToDoListLoadedState;
              if (currentState.showHistory) {
                bloc.add(ShowActiveEvent());
              } else {
                bloc.add(ShowHistoryEvent());
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ToDoListBloc, ToDoListState>(
        builder: (context, state) {
          if (state is ToDoListLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ToDoListLoadedState) {
            if (state.displayedTasks.isEmpty) {
              return Center(
                child: Text(
                  "There is no ${state.showHistory ? 'old ' : 'active '}To-Do yet",
                ),
              );
            }

            return ListView.builder(
              itemCount: state.displayedTasks.length,
              itemBuilder: (context, index) {
                return ToDoItemWidget(toDoItem: state.displayedTasks[index]);
              },
            );
          }

          return const Center(child: Text("Something went wrong"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        onPressed: () async {
          final newItem = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddToDoItemScreen()),
          );
          if (newItem != null) {
            context.read<ToDoListBloc>().add(AddToDoEvent(newItem));
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
