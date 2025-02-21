class ToDoItem {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime dateTime;
  final String priority;

  ToDoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.priority,
    this.isCompleted = false,
  });
  ToDoItem copyWith({
    bool? isCompleted,
  }) {
    return ToDoItem(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted ?? this.isCompleted,
      dateTime: dateTime,
      priority: priority,
    );
  }
}