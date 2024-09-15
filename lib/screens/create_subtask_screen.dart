import 'package:flutter/material.dart';

class CreateSubtaskScreen extends StatefulWidget {
  const CreateSubtaskScreen({super.key});

  @override
  _CreateSubtaskScreenState createState() => _CreateSubtaskScreenState();
}

class _CreateSubtaskScreenState extends State<CreateSubtaskScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _subtaskTitleController = TextEditingController();
  final TextEditingController _assigneeController = TextEditingController();
  final TextEditingController _reporterController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _reminderTimeController = TextEditingController();

  String _selectedStatus = 'Pending'; // Default status

  // List of status options
  final List<String> _statusOptions = [
    'Pending',
    'In Progress',
    'Completed',
    'Scheduled',
    'On Hold',
  ];

  // A function to handle form submission
  void _submitSubtask() {
    if (_formKey.currentState!.validate()) {
      // Process the form data here and save it to your task list
      print('Subtask Title: ${_subtaskTitleController.text}');
      print('Assignee: ${_assigneeController.text}');
      print('Reporter: ${_reporterController.text}');
      print('Description: ${_descriptionController.text}');
      print('Reminder Time: ${_reminderTimeController.text}');
      print('Status: $_selectedStatus');
      // Add logic to save the subtask
      Navigator.pop(context); // Go back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          'Create Subtask',
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
                  // Subtask Title
                  TextFormField(
                    controller: _subtaskTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Subtask Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter subtask title';
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Reminder Time
                  TextFormField(
                    controller: _reminderTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Reminder Time',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter reminder time';
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

                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitSubtask,
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
