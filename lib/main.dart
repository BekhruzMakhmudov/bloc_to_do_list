import 'package:bloc_to_do_list/config/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/to_do_list/presentation/bloc/todo_bloc.dart';
import 'features/to_do_list/presentation/pages/todo_list_page.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TodoBloc>()..add(GetTodosEvent()),
      child: MaterialApp(
        title: 'Todo App',
        theme: themes(),
        home: const TodoListPage(),
      ),
    );
  }
}