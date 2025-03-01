import 'package:bloc_to_do_list/features/to_do_list/domain/entities/category.dart';
import 'package:bloc_to_do_list/features/to_do_list/domain/entities/priority.dart';
import 'package:bloc_to_do_list/features/to_do_list/domain/entities/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/format_datetime.dart';
import '../bloc/todo_bloc.dart';

class ToDoItem extends StatelessWidget {
  final Todo toDo;

  const ToDoItem({super.key, required this.toDo});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: toDo.priority.color.withAlpha(90),
      child: CheckboxListTile(
        value: toDo.isCompleted,
        onChanged: (newValue) {
          context.read<TodoBloc>().add(
                AddTodoEvent(
                  todo: toDo.copyWith(isCompleted: true),
                ),
              );
        },
        controlAffinity: ListTileControlAffinity.leading,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              toDo.category.name,
              style: TextStyle(
                decoration: toDo.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            Icon(toDo.category.icon),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(toDo.description),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Priority: ${toDo.priority.name}'),
                Text(
                  formatDateTime(toDo.createdAt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
