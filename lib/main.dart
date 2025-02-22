import 'package:bloc_to_do_list/presentation/bloc/to_do_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/models/to_do_item.dart';
import 'presentation/screens/to_do_list_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoItemAdapter());
  await Hive.openBox('todo_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: BlocProvider(
        create: (context) => ToDoListBloc(),
        child: ToDoListScreen(),
      ),
    );
  }
}
