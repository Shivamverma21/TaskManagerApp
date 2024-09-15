import 'package:flutter/material.dart';
import 'screens/task_list_screen.dart';
import 'package:provider/provider.dart';
import './providers/task_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

// Initialize the local notifications plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Android Initialization Settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  // Initialization Settings for both Android and iOS
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // iOS initialization settings can be added here if needed
  );

  // Initialize the local notifications plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  tz.initializeTimeZones();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        // Add other providers here if needed
      ],
      child: TaskManagerApp(), // Use TaskManagerApp as the root widget
    ),
  );
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',  // Add a title for the MaterialApp
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(), // Set the home screen
    );
  }
}
