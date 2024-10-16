import 'package:flutter/foundation.dart';
import '../model/task.dart';
import '../services/database_helper.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  final String _searchQuery = '';
  String get searchQuery => _searchQuery;

  TaskViewModel() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper.instance.getTasks();
    _tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await DatabaseHelper.instance.insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await DatabaseHelper.instance.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    await loadTasks();
  }

  List<Task> searchTasks(String query) {
    if (query.isEmpty) {
      return [];
    }
    return _tasks
        .where((task) =>
            task.title.toLowerCase().contains(query.toLowerCase()) ||
            task.description.toLowerCase().contains(query.toLowerCase()) ||
            task.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
