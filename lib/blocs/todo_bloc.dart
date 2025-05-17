import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/models/todo_model.dart';
import 'package:todo_bloc/repositories/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _repository;

  TodoBloc(this._repository) : super(TodoLoading()) {
    on<LoadTodos>((event, emit) {
      _repository.getTodos().listen((todos) => add(_TodosUpdated(todos)));
    });

    on<_TodosUpdated>((event, emit) {
      emit(TodoLoaded(event.todos));
    });

    on<AddTodo>((event, emit) async {
      await _repository.addTodo(event.title, event.description, event.datetime);
    });

    on<UpdateTodo>((event, emit) async {
      await _repository.updateTodo(
        event.todo.copyWith(
          createdAt: DateTime.now(),
          isDone: !event.todo.isDone,
          title: event.todo.title,
          description: event.todo.description,
          id: event.todo.id,
        ),
      );
    });

    on<DeleteTodo>((event, emit) async {
      await _repository.deleteTodo(event.id);
    });
  }
}

class _TodosUpdated extends TodoEvent {
  final List<Todo> todos;
  _TodosUpdated(this.todos);
}
