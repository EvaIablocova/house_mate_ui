class Task {
  final int? id;
  final String title;
  final String description;
  final bool completed;
  final DateTime? dueDate;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.completed = false,
    this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'] ?? false,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "completed": completed,
      "dueDate": dueDate?.toIso8601String(),
    };
  }
}
