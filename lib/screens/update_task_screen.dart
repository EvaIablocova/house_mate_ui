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
  DateTime? dueDate;
  Importance? importance;
  Status? status;
  int? effort;
  int? assignTo;
  String? notes;

  @override
  void initState() {
    super.initState();
    title = widget.task.title;
    description = widget.task.description;
    completed = widget.task.completed;
    dueDate = widget.task.dueDate;
    importance = widget.task.importance;
    status = widget.task.status;
    effort = widget.task.effort;
    assignTo = widget.task.assignTo;
    notes = widget.task.notes;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final updatedTask = Task(
        id: widget.task.id,
        title: title,
        description: description,
        completed: completed,
        dueDate: dueDate,
        importance: importance,
        status: status,
        effort: effort,
        assignTo: assignTo,
        notes: notes,
      );
      await TaskApi.updateTask(updatedTask);
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
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
      appBar: AppBar(title: const Text("Update Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
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
              DropdownButtonFormField<Importance>(
                value: importance,
                decoration: const InputDecoration(labelText: "Importance"),
                items: Importance.values
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.toString().split('.').last),
                ))
                    .toList(),
                onChanged: (val) => setState(() => importance = val),
              ),
              DropdownButtonFormField<Status>(
                value: status,
                decoration: const InputDecoration(labelText: "Status"),
                items: Status.values
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.toString().split('.').last),
                ))
                    .toList(),
                onChanged: (val) => setState(() => status = val),
              ),
              TextFormField(
                initialValue: effort?.toString(),
                decoration: const InputDecoration(labelText: "Effort"),
                keyboardType: TextInputType.number,
                onChanged: (val) => effort = int.tryParse(val),
              ),
              TextFormField(
                initialValue: assignTo?.toString(),
                decoration: const InputDecoration(labelText: "Assign To (User ID)"),
                keyboardType: TextInputType.number,
                onChanged: (val) => assignTo = int.tryParse(val),
              ),
              TextFormField(
                initialValue: notes,
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
              const SizedBox(height: 20),
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
