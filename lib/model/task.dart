enum TaskPriority { low, medium, high }

class Task {
  int? id;
  String title;
  String description;
  bool isCompleted;
  DateTime? dueDate;
  TaskPriority priority;
  String category;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.category = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.index,
      'category': category,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: TaskPriority.values[map['priority']],
      category: map['category'],
    );
  }
}

List<Task> getSampleTasks() {
  return [
    Task(
      id: 1,
      title: "Complete project proposal",
      description: "Finish and submit the project proposal for client review",
      isCompleted: false,
      dueDate: DateTime.now().add(const Duration(days: 7)),
      priority: TaskPriority.high,
      category: "Work",
    ),
    Task(
      id: 2,
      title: "Buy groceries",
      description: "Purchase items for weekly meal prep",
      isCompleted: true,
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      priority: TaskPriority.medium,
      category: "Personal",
    ),
    Task(
      id: 3,
      title: "Schedule dentist appointment",
      description: "Book a check-up with Dr. Smith",
      isCompleted: false,
      dueDate: DateTime.now().add(const Duration(days: 14)),
      priority: TaskPriority.low,
      category: "Health",
    ),
    Task(
      id: 4,
      title: "Prepare presentation slides",
      description: "Create slides for the upcoming team meeting",
      isCompleted: false,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: TaskPriority.high,
      category: "Work",
    ),
    Task(
      id: 5,
      title: "Pay utility bills",
      description: "Pay electricity and water bills online",
      isCompleted: true,
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      priority: TaskPriority.medium,
      category: "Finance",
    ),
    Task(
      id: 6,
      title: "Go for a run",
      description: "30-minute jog in the park",
      isCompleted: false,
      dueDate: DateTime.now(),
      priority: TaskPriority.low,
      category: "Health",
    ),
    Task(
      id: 7,
      title: "Read chapter 5 of textbook",
      description: "Study for upcoming exam",
      isCompleted: false,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      priority: TaskPriority.medium,
      category: "Education",
    ),
    Task(
      id: 8,
      title: "Call mom",
      description: "Weekly catch-up call with family",
      isCompleted: true,
      dueDate: DateTime.now().subtract(const Duration(days: 3)),
      priority: TaskPriority.low,
      category: "Personal",
    ),
    Task(
      id: 9,
      title: "Fix leaky faucet",
      description: "Repair the kitchen sink",
      isCompleted: false,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: TaskPriority.medium,
      category: "Home",
    ),
    Task(
      id: 10,
      title: "Submit expense report",
      description: "Compile and submit last month's expenses",
      isCompleted: false,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.high,
      category: "Work",
    ),
  ];
}
