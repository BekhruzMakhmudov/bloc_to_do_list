import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'features/to_do_list/data/datasources/todo_local_datasource.dart';
import 'features/to_do_list/data/models/todo_model.dart';
import 'features/to_do_list/data/repositories/todo_repository_impl.dart';
import 'features/to_do_list/domain/repositories/todo_repository.dart';
import 'features/to_do_list/domain/usecases/usecases.dart';
import 'features/to_do_list/presentation/bloc/todo_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  Hive.registerAdapter(TodoModelAdapter());
  final todoBox = await Hive.openBox<TodoModel>('todos');
  sl.registerLazySingleton<Box<TodoModel>>(() => todoBox);

  sl.registerLazySingleton<TodoLocalDataSource>(
        () => TodoLocalDataSourceImpl(todoBox: sl()),
  );
  sl.registerLazySingleton<TodoRepository>(
        () => TodoRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetTodos(sl()));
  sl.registerLazySingleton(() => GetTodoById(sl()));
  sl.registerLazySingleton(() => AddTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));
  sl.registerFactory(
        () => TodoBloc(
      getTodos: sl(),
      getTodoById: sl(),
      addTodo: sl(),
      deleteTodo: sl(),
    ),
  );
}