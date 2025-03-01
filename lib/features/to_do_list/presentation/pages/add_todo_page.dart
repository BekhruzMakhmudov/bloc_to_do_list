import 'package:bloc_to_do_list/features/to_do_list/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/todo.dart';
import '../bloc/todo_bloc.dart';

class AddTodoPage extends StatefulWidget {
  final Todo? todo;

  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;
  late Category _selectedCategory;
  late Priority _selectedPriority;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.todo?.description,
    );
    _selectedCategory = widget.todo?.category ?? Category.other;
    _selectedPriority = widget.todo?.priority ?? Priority.medium;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
        leading: BackButton(
          onPressed: () {
            if (widget.todo != null) {
              context.read<TodoBloc>().add(
                    AddTodoEvent(todo: widget.todo!),
                  );
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInput(
                controller: _descriptionController,
                label: 'Description',
              ),
              _buildDropDownMenu(
                label: 'Category:',
                selected: _selectedCategory,
                onChanged: (Category? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
                items: Category.values.skip(1)
                    .map(
                      (item) => DropdownMenuItem<Category>(
                        value: item,
                        child: Row(
                          children: [
                            Icon(item.icon),
                            SizedBox(width: 4),
                            Text(item.name),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              _buildDropDownMenu(
                label: 'Priority:',
                selected: _selectedPriority,
                onChanged: (Priority? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedPriority = newValue;
                    });
                  }
                },
                items: Priority.values
                    .map(
                      (item) => DropdownMenuItem<Priority>(
                        value: item,
                        child: Text(
                          item.name,
                          style: TextStyle(
                            color: item.color,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              Center(
                child: _buildSubmitButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildDropDownMenu<T>({
    required String label,
    required T selected,
    required ValueChanged<T?> onChanged,
    List<DropdownMenuItem<T>>? items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 8),
          DropdownButton<T>(
            value: selected,
            onChanged: onChanged,
            items: items,
          ),
        ],
      ),
    );
  }

  _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final description = _descriptionController.text;
          final Todo newTodo;
          if (widget.todo == null) {
            newTodo = Todo(
              id: const Uuid().v4(),
              category: _selectedCategory,
              description: description,
              createdAt: DateTime.now(),
              priority: _selectedPriority,
            );
          } else {
            newTodo = widget.todo!.copyWith(
              category: _selectedCategory,
              description: description,
              priority: _selectedPriority,
            );
          }
          context.read<TodoBloc>().add(AddTodoEvent(todo: newTodo));
          context.read<TodoBloc>().add(GetTodosEvent(
                category: _selectedCategory,
                showHistory: newTodo.isCompleted,
              ));
          Navigator.of(context).pop();
        }
      },
      child: Text(
        'Add',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
