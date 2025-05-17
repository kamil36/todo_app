import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_bloc/models/todo_model.dart';

class TodoRepository {
  final _todoRef = FirebaseFirestore.instance.collection('todos');

  Stream<List<Todo>> getTodos() {
    return _todoRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Todo.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> addTodo(String title, String description, String string) async {
    await _todoRef.add({'title': title, 'isDone': false, 'createdAt': DateTime.now(),
      'description': description});
  }

  Future<void> updateTodo(Todo todo) async {
    await _todoRef.doc(todo.id).update({
      'title': todo.title,
      'description': todo.description,
      'isDone': todo.isDone,
      'createdAt': todo.createdAt,
    });
  }

  Future<void> deleteTodo(String id) async {
    await _todoRef.doc(id).delete();
  }
}