import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'create_task_screen.dart';
import 'completed_tasks_screen.dart';
import 'task_details_screen.dart';

class TaskListScreen extends StatelessWidget {
  TaskListScreen({super.key});

  Future<void> _exportTasks(BuildContext context) async {
    final tasks = Provider.of<TaskProvider>(context, listen: false).tasks;

    // Get the Downloads directory to store the file
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to access external storage.')),
      );
      return;
    }
    
    final timestamp = DateTime.now().millisecondsSinceEpoch; // Create a unique timestamp
    final filePath = '${directory.path}/tasks_export_$timestamp.csv'; // Unique file name

    final file = File(filePath);
    String csvData = "Task ID,Task Title,Task Status\n";
    for (var task in tasks) {
      csvData += "${task.id},${task.taskTitle},${task.status}\n";
    }

    await file.writeAsString(csvData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tasks exported successfully! File saved at $filePath')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text('Task Manager', style: TextStyle(fontSize: 24)),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.nonCompletedTasks;
          final completedTasks = taskProvider.completedTasks;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(
                              task: task, // Pass the task object to TaskDetailScreen
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          task.taskTitle,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to Create Task screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateTaskScreen()),
                    );
                  },
                  icon: const Icon(Icons.add), // Add icon here
                  label: const Text("Create Task"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    minimumSize: const Size.fromHeight(50), // Full-width button
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle completed tasks
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CompletedTasksScreen(
                        completedTasks: completedTasks,
                      )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size.fromHeight(50), // Full-width button
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text("Completed Tasks"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: ElevatedButton(
                  onPressed: () => _exportTasks(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size.fromHeight(50),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text("Export Tasks"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
