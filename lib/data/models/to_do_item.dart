import 'package:bloc_to_do_list/data/models/priority.dart';
import 'package:hive/hive.dart';

part 'to_do_item.g.dart';

@HiveType(typeId: 0)
class ToDoItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime dateTime;

  @HiveField(5)
  final Priority priority;

  ToDoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.dateTime,
    required this.priority,
  });

  ToDoItem copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dateTime,
    Priority? priority,
  }) {
    return ToDoItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dateTime: dateTime ?? this.dateTime,
      priority: priority ?? this.priority,
    );
  }
}