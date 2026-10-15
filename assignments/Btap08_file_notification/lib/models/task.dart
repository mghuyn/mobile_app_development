import 'dart:convert';

class Task {
  final int id;
  final String title;
  final DateTime reminderTime;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.reminderTime,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'reminderTime': reminderTime.toIso8601String(),
        'completed': completed,
      };

  String toFileString() => jsonEncode(toJson());

  factory Task.fromString(String line) {
    final data = jsonDecode(line) as Map<String, dynamic>;
    return Task(
      id: data['id'] as int,
      title: data['title'] as String,
      reminderTime: DateTime.parse(data['reminderTime'] as String),
      completed: data['completed'] as bool? ?? false,
    );
  }
}
