import 'package:flutter/material.dart';

class TextInput extends StatefulWidget{
  final TextEditingController controller;
  final String label;
  const TextInput({super.key, required this.controller, required this.label});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (value) => setState(() {
        widget.controller.text;
      }),
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
          onPressed: () => setState(() {
            widget.controller.clear();
          }),
          icon: Icon(Icons.clear),
        )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a ${widget.label}';
        }
        return null;
      },
    );
  }
}