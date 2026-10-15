import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/todo.dart';

class FileService {
  Future<File> get _file async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/todo.txt');
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final file = await _file;
    final data = todos.map((e) => e.toFileString()).join('\n');
    await file.writeAsString(data, flush: true);
  }

  Future<List<Todo>> loadTodos() async {
    try {
      final file = await _file;
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      return content
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .map(Todo.fromString)
          .toList();
    } catch (_) {
      return [];
    }
  }
}
