import 'package:flutter/material.dart';

enum TaskPriority {
  low,
  medium,
  high,
}

extension TaskPriorityExtension on TaskPriority {
  String toShortString() {
    return this.toString().split('.').last.toUpperCase();
  }

  static TaskPriority fromString(String value) {
    switch (value.toUpperCase()) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      default:
        throw Exception("Unknown priority: $value");
    }
  }
}

class Task {
  String title;
  String description;
  DateTime date;
  TimeOfDay time;
  bool isCompleted;
  TaskPriority priority;

  Task({
    required this.title,
    this.description = '',
    required this.date,
    required this.time,
    this.isCompleted = false,
    this.priority = TaskPriority.low,
  });
}
