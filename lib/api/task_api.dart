import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskApi {
  static const String baseUrl = "http://localhost:8081/tasks";

  // --- CRUD ---

  static Future<List<Task>> getAllTasks() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  static Future<Task> getTaskById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception("Task not found");
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

  static Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 204) {
      throw Exception("Failed to delete task");
    }
  }

  // --- Queries from updated controller ---

  static Future<List<Task>> getTasksByCompletion(bool completed) async {
    final response = await http.get(Uri.parse("$baseUrl/completed/$completed"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load tasks by completion");
    }
  }

  static Future<List<Task>> getTasksByStatus(String status) async {
    final response = await http.get(Uri.parse("$baseUrl/status/$status"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load tasks by status");
    }
  }

  static Future<List<Task>> getTasksByImportance(String importance) async {
    final response = await http.get(Uri.parse("$baseUrl/importance/$importance"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load tasks by importance");
    }
  }

  static Future<List<Task>> getTasksByEffortMin(int effort) async {
    final response = await http.get(Uri.parse("$baseUrl/effort/min/$effort"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load tasks by min effort");
    }
  }

  static Future<List<Task>> getTasksByEffortMax(int effort) async {
    final response = await http.get(Uri.parse("$baseUrl/effort/max/$effort"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load tasks by max effort");
    }
  }

  static Future<List<Task>> getTasksAssignedTo(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/assigned/$userId"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load tasks by user assignment");
    }
  }

  static Future<List<Task>> searchTasksByTitle(String keyword) async {
    final response = await http.get(Uri.parse("$baseUrl/search/title?keyword=$keyword"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to search tasks by title");
    }
  }

  static Future<List<Task>> searchTasksByDescription(String keyword) async {
    final response = await http.get(Uri.parse("$baseUrl/search/description?keyword=$keyword"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to search tasks by description");
    }
  }

  static Future<List<Task>> getPendingTasks() async {
    final response = await http.get(Uri.parse("$baseUrl/pending"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load pending tasks");
    }
  }
}
