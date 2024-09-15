import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure intl package is added to pubspec.yaml
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'create_subtask_screen.dart';
import '../services/notification_service.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _assigneeController = TextEditingController();
  final TextEditingController _reporterController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _reminderTimeController = TextEditingController();

  DateTime? _reminderTime; // Hold the selected reminder time
  String _selectedStatus = 'Pending'; // Default status
  final List<Subtask> _subtasks = []; // List to store subtasks

  // List of status options
  final List<String> _statusOptions = [
    'Pending',
    'In Progress',
    'Completed',
    'Scheduled',
    'On Hold',
  ];

  // Function to show date picker and time picker
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
          _reminderTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          _reminderTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(_reminderTime!);
        });
      }
    }
  }

  // A function to handle form submission
  void _submitTask() {
  if (_formKey.currentState!.validate()) {
    if (_reminderTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a reminder time')),
      );
      return;
    }

    // Create a new task object
    Task newTask = Task(
      id: 0, // Placeholder value, will be set by TaskProvider
      taskTitle: _taskTitleController.text,
      assignee: _assigneeController.text,
      reporter: _reporterController.text,
      description: _descriptionController.text,
      reminderTime: _reminderTime!,
      status: _selectedStatus,
      subtasks: _subtasks,
    );

    // Add the new task to the provider
    Provider.of<TaskProvider>(context, listen: false).addTask(newTask);

    // Schedule a notification for the task's reminder time
    NotificationService().scheduleNotification(
      newTask.id,
      'Reminder for ${newTask.taskTitle}',
      newTask.description,
      newTask.reminderTime,
    );

    // Navigate back after task creation
    Navigator.pop(context);
  }
}

  // Callback to add a subtask
  void _addSubtask(Subtask subtask) {
    setState(() {
      _subtasks.add(subtask); // Add subtask to the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          'Create Task',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Title
                  TextFormField(
                    controller: _taskTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter task title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Assignee
                  TextFormField(
                    controller: _assigneeController,
                    decoration: const InputDecoration(
                      labelText: 'Assignee',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter assignee';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Reporter
                  TextFormField(
                    controller: _reporterController,
                    decoration: const InputDecoration(
                      labelText: 'Reporter',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter reporter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reminder Time
                  TextFormField(
                    controller: _reminderTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Reminder Time (yyyy-MM-dd HH:mm)',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: _selectDateTime, // Show date-time picker
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a reminder time';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Status Dropdown
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
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a status';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Add Subtask Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Navigate to subtask creation screen
                      final Subtask? subtask = await Navigator.push<Subtask>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateSubtaskScreen(),
                        ),
                      );
                      if (subtask != null) {
                        _addSubtask(subtask); // Add the subtask
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Subtask'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      minimumSize: const Size.fromHeight(50),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size.fromHeight(50),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
