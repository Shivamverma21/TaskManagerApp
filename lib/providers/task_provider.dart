import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  int _currentTaskId = 0;  // Counter for task IDs
  int _currentSubtaskId = 0; // Counter for subtask IDs

  List<Task> get tasks => _tasks;

  List<Task> get nonCompletedTasks =>
      _tasks.where((task) => task.status != "Completed").toList();

  List<Task> get completedTasks =>
      _tasks.where((task) => task.status == "Completed").toList();

  // Add a new task with a unique ID
  void addTask(Task task) {
    task.id = _currentTaskId++;  // Assign a unique ID to the task
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = updatedTask;
      notifyListeners(); // This is crucial to update UI
    } else {
      print('Task with ID: ${updatedTask.id} not found'); // Debug print
    }
  }

  // Update the status of a task
  void updateTaskStatus(Task task, String newStatus) {
    task.status = newStatus;
    notifyListeners();
  }

  // Add a subtask to a specific task with a unique ID
  void addSubtask(Task parentTask, Subtask subtask) {
    subtask.id = _currentSubtaskId++;  // Assign a unique ID to the subtask
    parentTask.subtasks.add(subtask);
    notifyListeners();
  }

  // Update the status of a specific subtask within a task
  void updateSubtaskStatus(Task parentTask, Subtask subtask, String newStatus) {
    int subtaskIndex = parentTask.subtasks.indexWhere((s) => s.id == subtask.id);
    if (subtaskIndex != -1) {
      parentTask.subtasks[subtaskIndex].status = newStatus;
      notifyListeners();
    }
  }

  // Delete a task
  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  // Delete a subtask from a task
  void deleteSubtask(Task parentTask, Subtask subtask) {
    parentTask.subtasks.removeWhere((s) => s.id == subtask.id);
    notifyListeners();
  }

  // Set the entire list of tasks
  void setTasks(List<Task> tasks) {
    _tasks.clear(); // Clear existing tasks
    _tasks.addAll(tasks); // Add new tasks
    notifyListeners();
  }
}
