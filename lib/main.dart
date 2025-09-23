import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoListApp());
}

class ToDoListApp extends StatelessWidget {
  const ToDoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class Task {
  String title;
  bool isDone;

  Task({required this.title, this.isDone = false});
}

class _HomePageState extends State<HomePage> {
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _addTask(String title) {
    if (title.isEmpty) return;
    setState(() {
      _tasks.add(Task(title: title));
    });
    _taskController.clear();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Tugas"),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(
            hintText: "Masukkan nama tugas...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              _addTask(_taskController.text);
              Navigator.pop(context);
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📋 To-Do List"),
        centerTitle: true,
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                "Belum ada tugas.\nYuk tambah sekarang!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isDone,
                      onChanged: (_) => _toggleTask(index),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.isDone ? Colors.grey : Colors.black,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTask(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
