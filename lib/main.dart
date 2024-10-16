// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:task_manager/model/task.dart';
import 'views/task_list_view.dart';
import 'viewmodels/task_view_model.dart';

// void addSampleTasks(TaskViewModel viewModel) {
//   final sampleTasks = getSampleTasks();
//   for (var task in sampleTasks) {
//     viewModel.addTask(task);
//   }
// }

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final viewModel = TaskViewModel();
        // addSampleTasks(viewModel);
        return viewModel;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.system,
      home: const TaskListView(),
    );
  }
}
