import 'package:bloc_to_do_list/features/to_do_list/domain/entities/category.dart';
import 'package:bloc_to_do_list/features/to_do_list/domain/entities/priority.dart';

class Todo {
  final String id;
  final Category category;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final Priority priority;

  Todo({
    required this.id,
    required this.category,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.priority = Priority.medium,
  });

  Todo copyWith({
    String? id,
    Category? category,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    Priority? priority,
  }) {
    return Todo(
      id: id ?? this.id,
      category: category ?? this.category,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
    );
  }
}