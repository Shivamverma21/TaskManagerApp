import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _assigneeController;
  late TextEditingController _reporterController;
  late TextEditingController _descriptionController;
  late TextEditingController _reminderTimeController;
  late String _selectedStatus;

  bool _isEditing = false;

  final List<String> _statusOptions = [
    'Pending',
    'In Progress',
    'Completed',
    'Scheduled',
    'On Hold',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.taskTitle);
    _assigneeController = TextEditingController(text: widget.task.assignee);
    _reporterController = TextEditingController(text: widget.task.reporter);
    _descriptionController = TextEditingController(text: widget.task.description);
    _reminderTimeController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm').format(widget.task.reminderTime),
    );
    _selectedStatus = widget.task.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _assigneeController.dispose();
    _reporterController.dispose();
    _descriptionController.dispose();
    _reminderTimeController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _updateTask() {
    DateTime? reminderTime;
    try {
      reminderTime = DateFormat('yyyy-MM-dd HH:mm').parse(_reminderTimeController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid date format. Use yyyy-MM-dd HH:mm')),
      );
      return;
    }

    final updatedTask = Task(
      id: widget.task.id,
      taskTitle: _titleController.text,
      assignee: _assigneeController.text,
      reporter: _reporterController.text,
      description: _descriptionController.text,
      reminderTime: reminderTime,
      status: _selectedStatus,
      subtasks: widget.task.subtasks,
    );

    Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask);

    // Schedule a notification for the updated task's reminder time
    NotificationService().scheduleNotification(
      updatedTask.id,
      'Reminder for ${updatedTask.taskTitle}',
      updatedTask.description,
      updatedTask.reminderTime,
    );

    Navigator.pop(context); // Return to previous screen after update
  }

  void _updateSubtaskStatus(Subtask subtask, String newStatus) {
    Provider.of<TaskProvider>(context, listen: false).updateSubtaskStatus(widget.task, subtask, newStatus);
  }

  Future<void> _selectDateTime() async {
    DateTime now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (selectedTime != null) {
        setState(() {
          final selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          _reminderTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
        });
      }
    }
  }

  void _showNotification() {
    // Display a basic notification
    NotificationService().showNotification(
      1, // Notification ID
      'Task Notification',
      'This is a notification for task: ${widget.task.taskTitle}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text('Task Details', style: TextStyle(fontSize: 24)),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEditMode,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title',
                        border: OutlineInputBorder(),
                      ),
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _assigneeController,
                      decoration: const InputDecoration(
                        labelText: 'Assignee',
                        border: OutlineInputBorder(),
                      ),
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _reporterController,
                      decoration: const InputDecoration(
                        labelText: 'Reporter',
                        border: OutlineInputBorder(),
                      ),
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _reminderTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Reminder Time (yyyy-MM-dd HH:mm)',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true, // Ensure keyboard does not appear
                      onTap: _selectDateTime, // Show date-time picker
                      enabled: _isEditing, // Enable only if editing
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: _statusOptions.map((status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: _isEditing
                          ? (value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                            }
                          : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a status';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    if (_isEditing)
                      ElevatedButton(
                        onPressed: _updateTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          minimumSize: const Size.fromHeight(50),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: Text('Update'),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Subtasks section
              if (widget.task.subtasks.isNotEmpty) ...[
                const Text(
                  'Subtasks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...widget.task.subtasks.map((subtask) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(subtask.subtaskTitle),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Assignee: ${subtask.assignee}'),
                          Text('Description: ${subtask.description}'),
                          Text('Reminder Time: ${DateFormat('yyyy-MM-dd HH:mm').format(subtask.reminderTime)}'),
                          Text('Status: ${subtask.status}'),
                        ],
                      ),
                      trailing: _isEditing
                          ? DropdownButton<String>(
                              value: subtask.status,
                              items: _statusOptions.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (newStatus) {
                                if (newStatus != null) {
                                  _updateSubtaskStatus(subtask, newStatus);
                                }
                              },
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ],

              const SizedBox(height: 30),

              // Notification Button
              Center(
                child: ElevatedButton(
                  onPressed: _showNotification,
                  child: Text('Show Notification'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.blueAccent,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
