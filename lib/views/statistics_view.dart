import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/task.dart';
import '../viewmodels/task_view_model.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final tasks = taskViewModel.tasks;

    int completedTasks = tasks.where((task) => task.isCompleted).length;
    int pendingTasks = tasks.length - completedTasks;

    Map<TaskPriority, int> priorityCounts = {
      for (var priority in TaskPriority.values) priority: 0
    };
    for (var task in tasks) {
      priorityCounts[task.priority] = (priorityCounts[task.priority] ?? 0) + 1;
    }

    Map<String, int> categoryCounts = {};
    for (var task in tasks) {
      if (task.category.isNotEmpty) {
        categoryCounts[task.category] =
            (categoryCounts[task.category] ?? 0) + 1;
      }
    }

// Sort the category entries
    List<MapEntry<String, int>> sortedCategories = categoryCounts.entries
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Take top 5 categories and create widgets
    List<Widget> categoryBars = sortedCategories
        .take(5)
        .map((entry) => _buildCategoryBar(
              context,
              entry.key,
              entry.value,
              tasks.length,
              Colors.blue,
            ))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.grey[200],
        title: const Text(
          'Task Statistics',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Task Overview',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildStatCard(
                        context, 'Completed', completedTasks, Colors.green),
                  ),
                  Expanded(
                      child: _buildStatCard(
                          context, 'Pending', pendingTasks, Colors.orange)),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Priority Distribution',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              ...TaskPriority.values.map((priority) => _buildPriorityBar(
                    context,
                    priority.toString().split('.').last,
                    priorityCounts[priority]!,
                    tasks.length,
                    _getPriorityColor(priority),
                  )),
              const SizedBox(height: 32),
              Text(
                'Top Categories',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              ...categoryBars,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, int value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBar(
      BuildContext context, String label, int count, int total, Color color) {
    double percentage = total > 0 ? count / total : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: $count'),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            value: percentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(
      BuildContext context, String label, int count, int total, Color color) {
    double percentage = total > 0 ? count / total : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: $count'),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            value: percentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }
}
