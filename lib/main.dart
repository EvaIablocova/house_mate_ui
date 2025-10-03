import 'package:flutter/material.dart';
import 'screens/task_screen.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Module',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TaskScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
