import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/views/statistics_view.dart';
import 'package:task_manager/views/task_form_view.dart';
import 'package:task_manager/views/task_search.dart';
import '../model/task.dart';
import '../viewmodels/task_view_model.dart';
import 'package:intl/intl.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  late ScrollController _scrollController;
  bool _isFabVisible = true;
  late String _currentDate;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _updateCurrentDate();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isFabVisible) {
        setState(() {
          _isFabVisible = false;
        });
      }
    }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isFabVisible) {
        setState(() {
          _isFabVisible = true;
        });
      }
    }
  }

  void _updateCurrentDate() {
    setState(() {
      _currentDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.grey[200],
        leading: IconButton(
          icon: const Icon(Icons.bar_chart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StatisticsView()),
            );
          },
        ),
        title: Column(
          children: [
            const Text(
              'Task Manager',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              _currentDate,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context)
                    .appBarTheme
                    .foregroundColor
                    ?.withOpacity(0.8),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: TaskSearch());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<TaskViewModel>(
          builder: (context, taskViewModel, child) {
            if (taskViewModel.tasks.isEmpty) {
              return const Center(child: Text('No tasks yet. Add one!'));
            } else {
              return ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                physics: const BouncingScrollPhysics(),
                itemCount: taskViewModel.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskViewModel.tasks[index];
                  return TaskListTile(task: task);
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _isFabVisible ? 1.0 : 0.0,
        child: FloatingActionButton(
          backgroundColor: Colors.green[800],
          foregroundColor: Colors.grey[200],
          onPressed: _isFabVisible
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TaskFormView()),
                  );
                }
              : null,
          child: const Icon(Icons.add),
        ),
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
