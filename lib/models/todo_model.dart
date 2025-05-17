import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isDone;

  Todo({
    required this.id,
    required this.title,
    required this.isDone,
    required this.description,
    required this.createdAt,
  });
  Todo copyWith({
    String? id,
    String? title,
    bool? isDone,
    String? description,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
      'description': description,
      'createdAt': createdAt,
    };
  }

  factory Todo.fromMap(String id, Map<String, dynamic> map) {
    return Todo(
      id: id,
      title: map['title'] ?? '',
      isDone: map['isDone'] ?? false,
      description: map['description'] ,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
