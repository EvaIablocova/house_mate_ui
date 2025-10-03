import 'package:flutter/material.dart';
import '../api/task_api.dart';
import '../models/task.dart';

class UpdateTaskScreen extends StatefulWidget {
  final Task task;
  const UpdateTaskScreen({super.key, required this.task});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late bool completed;

  @override
  void initState() {
    super.initState();
    title = widget.task.title;
    description = widget.task.description;
    completed = widget.task.completed;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final updatedTask = Task(
        id: widget.task.id,
        title: title,
        description: description,
        completed: completed,
        dueDate: widget.task.dueDate,
      );
      await TaskApi.updateTask(updatedTask);
      Navigator.pop(context, true); // return success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: "Title"),
                onChanged: (val) => title = val,
                validator: (val) => val!.isEmpty ? "Enter a title" : null,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: "Description"),
                onChanged: (val) => description = val,
              ),
              SwitchListTile(
                title: const Text("Completed"),
                value: completed,
                onChanged: (val) => setState(() => completed = val),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Update Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
