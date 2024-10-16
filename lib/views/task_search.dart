import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/viewmodels/task_view_model.dart';
import 'package:task_manager/model/task.dart';
import 'package:task_manager/views/task_form_view.dart';

class TaskSearch extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search tasks...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<TaskViewModel>(
        builder: (context, taskViewModel, child) {
          final tasks = taskViewModel.searchTasks(query);

          if (query.isEmpty) {
            return const Center(
              child: Text('Enter a search term to find tasks.'),
            );
          }

          if (tasks.isEmpty) {
            return Center(
              child: Text('No tasks found for "$query".'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            physics: const BouncingScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskListTile(task: task);
            },
          );
        },
      ),
    );
  }
}

class TaskListTile extends StatelessWidget {
  final Task task;

  const TaskListTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            if (task.dueDate != null)
              Text(
                'Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            Text('Priority: ${task.priority.toString().split('.').last}'),
            if (task.category.isNotEmpty) Text('Category: ${task.category}'),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: _getPriorityColor(task.priority),
          child: const Icon(
            Icons.assignment,
            color: Colors.white,
          ),
        ),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) {
            task.isCompleted = value ?? false;
            Provider.of<TaskViewModel>(context, listen: false).updateTask(task);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskFormView(task: task),
            ),
          );
        },
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
