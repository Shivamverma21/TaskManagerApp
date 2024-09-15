import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskmanagerapp/screens/task_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:taskmanagerapp/providers/task_provider.dart';

void main() {
  testWidgets('TaskListScreen displays buttons and task list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => TaskProvider()),
          ],
          child: TaskListScreen(),
        ),
      ),
    );

    // Verify that specific buttons are present in the TaskListScreen.
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text("Create Task"), findsOneWidget);
    expect(find.text("Completed Tasks"), findsOneWidget);
    expect(find.text("Export Tasks"), findsOneWidget);

    // Verify that the TaskListScreen starts with an empty list (assuming tasks are empty initially).
    expect(find.text('Task ID'), findsNothing); // Adjust according to your actual UI if needed

    // Optional: If you want to test interaction with a button, you can add the following code:
    // Tap the "Create Task" button and trigger a frame.
    await tester.tap(find.text("Create Task"));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Verify that the screen navigated to CreateTaskScreen (assuming you have a way to verify this)
    // You may need to use a navigator observer or similar approach to verify navigation
  });
}
