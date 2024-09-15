// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: (json['id'] as num).toInt(),
      taskTitle: json['taskTitle'] as String,
      assignee: json['assignee'] as String,
      reporter: json['reporter'] as String,
      description: json['description'] as String,
      reminderTime: DateTime.parse(json['reminderTime'] as String),
      status: json['status'] as String,
      subtasks: (json['subtasks'] as List<dynamic>?)
              ?.map((e) => Subtask.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'taskTitle': instance.taskTitle,
      'assignee': instance.assignee,
      'reporter': instance.reporter,
      'description': instance.description,
      'reminderTime': instance.reminderTime.toIso8601String(),
      'status': instance.status,
      'subtasks': instance.subtasks,
    };

Subtask _$SubtaskFromJson(Map<String, dynamic> json) => Subtask(
      id: (json['id'] as num).toInt(),
      subtaskTitle: json['subtaskTitle'] as String,
      assignee: json['assignee'] as String,
      description: json['description'] as String,
      reminderTime: DateTime.parse(json['reminderTime'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$SubtaskToJson(Subtask instance) => <String, dynamic>{
      'id': instance.id,
      'subtaskTitle': instance.subtaskTitle,
      'assignee': instance.assignee,
      'description': instance.description,
      'reminderTime': instance.reminderTime.toIso8601String(),
      'status': instance.status,
    };
