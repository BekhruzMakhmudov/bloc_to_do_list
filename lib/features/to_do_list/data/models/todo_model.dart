import 'package:hive/hive.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/todo.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int categoryIndex;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final int priorityIndex;

  TodoModel({
    required this.id,
    required this.categoryIndex,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.priorityIndex,
  });

  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      categoryIndex: todo.category.index,
      description: todo.description,
      isCompleted: todo.isCompleted,
      createdAt: todo.createdAt,
      priorityIndex: todo.priority.index,
    );
  }

  Todo toEntity() {
    return Todo(
      id: id,
      category: Category.values[categoryIndex],
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
      priority: Priority.values[priorityIndex],
    );
  }
}