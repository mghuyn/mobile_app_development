class Todo {
  final String title;
  final DateTime time;

  Todo({required this.title, required this.time});

  String toFileString() => '$title|${time.toIso8601String()}';

  static Todo fromString(String line) {
    final parts = line.split('|');
    if (parts.length < 2) {
      throw const FormatException('Dòng todo không hợp lệ');
    }
    return Todo(title: parts.first, time: DateTime.parse(parts.last));
  }
}
