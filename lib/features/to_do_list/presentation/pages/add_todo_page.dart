import 'package:bloc_to_do_list/features/to_do_list/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

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
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late Priority _selectedPriority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.todo?.title,
    );
    _descriptionController = TextEditingController(
      text: widget.todo?.description,
    );
    _selectedPriority = widget.todo?.priority ?? Priority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
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
              TextInput(controller: _titleController, label: 'Title'),
              const SizedBox(height: 16),
              TextInput(
                  controller: _descriptionController, label: 'Description'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Priority:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 8),
                    _buildDropDownMenu(),
                  ],
                ),
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

  _buildDropDownMenu() {
    return DropdownButton<Priority>(
      value: _selectedPriority,
      onChanged: (Priority? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedPriority = newValue;
          });
        }
      },
      items:
          Priority.values.map<DropdownMenuItem<Priority>>((Priority priority) {
        return DropdownMenuItem<Priority>(
          value: priority,
          child: Text(
            priority.name,
            style: TextStyle(
              color: priority.color,
            ),
          ),
        );
      }).toList(),
    );
  }

  _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final title = _titleController.text;
          final description = _descriptionController.text;
          if (widget.todo == null) {
            final newTodo = Todo(
              id: const Uuid().v4(),
              title: title,
              description: description,
              createdAt: DateTime.now(),
              priority: _selectedPriority,
            );
            context.read<TodoBloc>().add(AddTodoEvent(todo: newTodo));
          } else {
            final updatedTodo = widget.todo!.copyWith(
              title: title,
              description: description,
              priority: _selectedPriority,
            );
            context.read<TodoBloc>().add(AddTodoEvent(todo: updatedTodo));
          }
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
