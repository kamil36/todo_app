import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_bloc/blocs/todo_event.dart';
import 'package:todo_bloc/screens/home.dart';
import 'blocs/todo_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/todo_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => TodoRepository(),
      child: BlocProvider(
        create:
            (context) =>
                TodoBloc(context.read<TodoRepository>())..add(LoadTodos()),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
  }
}
