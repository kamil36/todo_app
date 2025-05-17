import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/blocs/todo_bloc.dart';
import 'package:todo_bloc/blocs/todo_event.dart';
import 'package:todo_bloc/blocs/todo_state.dart';
import 'package:todo_bloc/models/todo_model.dart';
import 'package:todo_bloc/screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController desccontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(LoadTodos());
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    desccontroller.dispose();
    super.dispose();
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titlecontroller,
                decoration: const InputDecoration(hintText: "Enter todo title"),
              ),
              TextField(
                controller: desccontroller,
                decoration: const InputDecoration(
                  hintText: "Enter todo description",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titlecontroller.text.trim().isNotEmpty) {
                  context.read<TodoBloc>().add(
                    AddTodo(
                      titlecontroller.text.trim(),
                      desccontroller.text.trim(),
                      DateTime.now().toString(),
                    ),
                  );
                  titlecontroller.clear();
                  desccontroller.clear();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Todo Added Successfully"),
                      action: SnackBarAction(
                        label: "OK",
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TodoBloc>();

    return Scaffold(
      backgroundColor: const Color(0xff002d4b),
      appBar: AppBar(
        backgroundColor: const Color(0xff0068a6),
        title: const Text(
          "Todo App with BLoC & Firebase",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/img/todo1.png",
                      fit: BoxFit.cover,
                      height: 200,
                      width: 200,
                    ),
                    SizedBox(height: 20),
                    const Text(
                      "No Todos Yet",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  final Todo todo = state.todos[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const TodoScreen();
                            },
                          ),
                        );
                      },
                      child: ListTile(
                        tileColor: const Color(0xff004c80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todo.description,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        leading: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            titlecontroller.text = todo.title;
                            desccontroller.text = todo.description;
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Edit Todo"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: titlecontroller,
                                        decoration: const InputDecoration(
                                          hintText: "Enter todo title",
                                        ),
                                      ),
                                      TextField(
                                        controller: desccontroller,
                                        decoration: const InputDecoration(
                                          hintText: "Enter todo description",
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        if (titlecontroller.text
                                            .trim()
                                            .isNotEmpty) {
                                          bloc.add(
                                            UpdateTodo(
                                              todo.copyWith(
                                                title:
                                                    titlecontroller.text.trim(),
                                                description:
                                                    desccontroller.text.trim(),
                                              ),
                                            ),
                                          );
                                          titlecontroller.clear();
                                          desccontroller.clear();
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                "Todo Updated Successfully",
                                              ),
                                              action: SnackBarAction(
                                                label: "OK",
                                                onPressed: () {
                                                  // Some code to undo the change.
                                                },
                                              ),
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text("Update"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            bloc.add(DeleteTodo(todo.id));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Todo Deleted Successfully",
                                ),
                                action: SnackBarAction(
                                  label: "OK",
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is TodoError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else {
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: const Color.fromARGB(255, 3, 77, 133),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
