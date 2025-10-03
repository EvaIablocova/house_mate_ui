import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskApi {
  static const String baseUrl = "http://localhost:8081/tasks";

  static Future<List<Task>> getAllTasks() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  static Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to create task");
    }
  }

  static Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 204) {
      throw Exception("Failed to delete task");
    }
  }

  static Future<Task> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${task.id}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to update task");
    }
  }

}
