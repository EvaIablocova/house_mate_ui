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
  Status? selectedStatus;
  Importance? selectedImportance;

  @override
  void initState() {
    super.initState();
    tasks = TaskApi.getAllTasks();
  }

  void _refreshTasks() {
    setState(() {
      if (selectedStatus != null) {
        tasks = TaskApi.getTasksByStatus(selectedStatus!.toString().split('.').last);
      } else if (selectedImportance != null) {
        tasks = TaskApi.getTasksByImportance(selectedImportance!.toString().split('.').last);
      } else {
        tasks = TaskApi.getAllTasks();
      }
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

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<Status>(
              value: selectedStatus,
              decoration: const InputDecoration(labelText: "Status"),
              items: [null, ...Status.values]
                  .map((s) => DropdownMenuItem(
                value: s,
                child: Text(s == null ? "All" : s.toString().split('.').last),
              ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedStatus = val;
                  selectedImportance = null;
                });
                _refreshTasks();
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<Importance>(
              value: selectedImportance,
              decoration: const InputDecoration(labelText: "Importance"),
              items: [null, ...Importance.values]
                  .map((i) => DropdownMenuItem(
                value: i,
                child: Text(i == null ? "All" : i.toString().split('.').last),
              ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedImportance = val;
                  selectedStatus = null;
                });
                _refreshTasks();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tasks")),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: FutureBuilder<List<Task>>(
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
                    return Card(
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text(
                          "${task.description}\n"
                              "Status: ${task.status?.toString().split('.').last ?? 'N/A'} | "
                              "Importance: ${task.importance?.toString().split('.').last ?? 'N/A'}",
                        ),
                        isThreeLine: true,
                        onTap: () => _navigateToUpdateTask(task),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(task.id!),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
