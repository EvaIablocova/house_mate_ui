import 'package:flutter/material.dart';
import '../api/task_api.dart';
import '../models/task.dart';
import 'new_task_screen.dart';
import 'update_task_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = TaskApi.getAllTasks();
  }

  void _refreshTasks() {
    setState(() {
      tasks = TaskApi.getAllTasks();
    });
  }

  void _deleteTask(int id) async {
    await TaskApi.deleteTask(id);
    _refreshTasks();
  }

  Future<void> _navigateToNewTask() async {
    final success = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewTaskScreen()),
    );
    if (success == true) {
      _refreshTasks();
    }
  }

  Future<void> _navigateToUpdateTask(Task task) async {
    final success = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UpdateTaskScreen(task: task)),
    );
    if (success == true) {
      _refreshTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      body: FutureBuilder<List<Task>>(
        future: tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No tasks found"));
          }
          final taskList = snapshot.data!;
          return ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              final task = taskList[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                onTap: () => _navigateToUpdateTask(task),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(task.id!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
