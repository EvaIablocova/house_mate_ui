enum Importance { LOW, MEDIUM, HIGH }
enum Status { NEW, IN_PROGRESS, COMPLETED, OVERDUE }

class Task {
  final int? id;
  final String title;
  final String description;
  final bool completed;
  final DateTime? dueDate;

  // --- New fields ---
  final int? timeEstimated;
  final int? timeReal;
  final String? periodOfExecution;
  final Importance? importance;
  final int? effort;
  final String? photoBefore;
  final String? photoAfter;
  final String? frequency;
  final int? frequencyEveryNumber;
  final String? frequencyEveryTimeUnit;
  final DateTime? frequencyStartOn;
  final DateTime? frequencyFinishOn;
  final bool? oneTime;
  final int? assignTo; // userId FK
  final String? notes;
  final Status? status;
  final String? attachments;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.completed = false,
    this.dueDate,
    this.timeEstimated,
    this.timeReal,
    this.periodOfExecution,
    this.importance,
    this.effort,
    this.photoBefore,
    this.photoAfter,
    this.frequency,
    this.frequencyEveryNumber,
    this.frequencyEveryTimeUnit,
    this.frequencyStartOn,
    this.frequencyFinishOn,
    this.oneTime,
    this.assignTo,
    this.notes,
    this.status,
    this.attachments,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      completed: json['completed'] ?? false,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      timeEstimated: json['timeEstimated'],
      timeReal: json['timeReal'],
      periodOfExecution: json['periodOfExecution'],
      importance: json['importance'] != null
          ? Importance.values.firstWhere(
            (e) => e.toString().split('.').last == json['importance'],
        orElse: () => Importance.LOW,
      )
          : null,
      effort: json['effort'],
      photoBefore: json['photoBefore'],
      photoAfter: json['photoAfter'],
      frequency: json['frequency'],
      frequencyEveryNumber: json['frequencyEveryNumber'],
      frequencyEveryTimeUnit: json['frequencyEveryTimeUnit'],
      frequencyStartOn: json['frequencyStartOn'] != null
          ? DateTime.parse(json['frequencyStartOn'])
          : null,
      frequencyFinishOn: json['frequencyFinishOn'] != null
          ? DateTime.parse(json['frequencyFinishOn'])
          : null,
      oneTime: json['oneTime'],
      assignTo: json['assignTo'],
      notes: json['notes'],
      status: json['status'] != null
          ? Status.values.firstWhere(
            (e) => e.toString().split('.').last == json['status'],
        orElse: () => Status.NEW,
      )
          : null,
      attachments: json['attachments'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "completed": completed,
      "dueDate": dueDate?.toIso8601String(),
      "timeEstimated": timeEstimated,
      "timeReal": timeReal,
      "periodOfExecution": periodOfExecution,
      "importance": importance?.toString().split('.').last,
      "effort": effort,
      "photoBefore": photoBefore,
      "photoAfter": photoAfter,
      "frequency": frequency,
      "frequencyEveryNumber": frequencyEveryNumber,
      "frequencyEveryTimeUnit": frequencyEveryTimeUnit,
      "frequencyStartOn": frequencyStartOn?.toIso8601String(),
      "frequencyFinishOn": frequencyFinishOn?.toIso8601String(),
      "oneTime": oneTime,
      "assignTo": assignTo,
      "notes": notes,
      "status": status?.toString().split('.').last,
      "attachments": attachments,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}
