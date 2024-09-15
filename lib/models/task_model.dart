import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart'; // This file will be generated

@JsonSerializable()
class Task {
  int id;
  String taskTitle;
  String assignee;
  String reporter;
  String description;
  DateTime reminderTime;
  String status;
  List<Subtask> subtasks;

  Task({
    required this.id,
    required this.taskTitle,
    required this.assignee,
    required this.reporter,
    required this.description,
    required this.reminderTime,
    required this.status,
    this.subtasks = const [],
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

@JsonSerializable()
class Subtask {
  int id;
  String subtaskTitle;
  String assignee;
  String description;
  DateTime reminderTime;
  String status;

  Subtask({
    required this.id,
    required this.subtaskTitle,
    required this.assignee,
    required this.description,
    required this.reminderTime,
    required this.status,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) => _$SubtaskFromJson(json);
  Map<String, dynamic> toJson() => _$SubtaskToJson(this);
}
