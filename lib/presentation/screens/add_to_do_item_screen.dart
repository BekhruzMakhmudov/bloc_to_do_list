import 'package:flutter/material.dart';
import '../../data/models/priority.dart';
import '../../domain/entities/to_do_item.dart';
import 'package:uuid/uuid.dart';

class AddToDoItemScreen extends StatefulWidget {
  const AddToDoItemScreen({super.key});

  @override
  State<AddToDoItemScreen> createState() => _AddToDoItemScreenState();
}

class _AddToDoItemScreenState extends State<AddToDoItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Priority _selectedPriority = Priority.medium;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add To-Do")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter description";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Priority: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<Priority>(
                    value: _selectedPriority,
                    onChanged: (Priority? newValue) {
                      setState(() {
                        _selectedPriority = newValue ?? Priority.medium;
                      });
                    },
                    items: Priority.values
                        .map<DropdownMenuItem<Priority>>(
                          (Priority value) => DropdownMenuItem<Priority>(
                            value: value,
                            child: Text(value.toString().split('.').last),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ToDoItem newItem = ToDoItem(
                      id: const Uuid().v4(),
                      title: _titleController.text,
                      description: _descriptionController.text,
                      isCompleted: false,
                      dateTime: DateTime.now(),
                      priority: _selectedPriority,
                    );
                    Navigator.pop(context, newItem);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
