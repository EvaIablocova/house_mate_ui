import 'package:flutter/material.dart';
import '../api/task_api.dart';
import '../models/task.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime? dueDate;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        title: title,
        description: description,
        dueDate: dueDate,
      );
      await TaskApi.createTask(newTask);
      Navigator.pop(context, true); // return success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Title"),
                onChanged: (val) => title = val,
                validator: (val) => val!.isEmpty ? "Enter a title" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                onChanged: (val) => description = val,
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Create Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
