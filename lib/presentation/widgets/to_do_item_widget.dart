import 'package:bloc_to_do_list/core/utils/get_formatted_date.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/to_do_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/to_do_list_bloc.dart';

class ToDoItemWidget extends StatelessWidget {
  final ToDoItem toDoItem;

  const ToDoItemWidget({super.key, required this.toDoItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: toDoItem.isCompleted,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (value) {
          if (value == true) {
            context.read<ToDoListBloc>().add(CompleteToDoEvent(
              toDoItem.copyWith(isCompleted: true),
            ));
          }
        },
        title: Text(
          toDoItem.title,
          style: TextStyle(
            decoration: toDoItem.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${toDoItem.description}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Priority: ${toDoItem.priority}"),
                Text(getFormattedDate(toDoItem.dateTime)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}