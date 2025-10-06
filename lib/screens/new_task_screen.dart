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
  Importance? importance;
  Status? status;
  int? effort;
  int? assignTo;
  String? notes;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        title: title,
        description: description,
        dueDate: dueDate,
        importance: importance,
        status: status,
        effort: effort,
        assignTo: assignTo,
        notes: notes,
      );
      await TaskApi.createTask(newTask);
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => dueDate = picked);
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
          child: ListView(
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
              DropdownButtonFormField<Importance>(
                decoration: const InputDecoration(labelText: "Importance"),
                items: Importance.values
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.toString().split('.').last),
                ))
                    .toList(),
                onChanged: (val) => importance = val,
              ),
              DropdownButtonFormField<Status>(
                decoration: const InputDecoration(labelText: "Status"),
                items: Status.values
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.toString().split('.').last),
                ))
                    .toList(),
                onChanged: (val) => status = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Effort"),
                keyboardType: TextInputType.number,
                onChanged: (val) => effort = int.tryParse(val),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Assign To (User ID)"),
                keyboardType: TextInputType.number,
                onChanged: (val) => assignTo = int.tryParse(val),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Notes"),
                onChanged: (val) => notes = val,
              ),
              Row(
                children: [
                  Text(dueDate == null
                      ? "No due date"
                      : "Due: ${dueDate!.toLocal()}".split(' ')[0]),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDueDate,
                  ),
                ],
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
