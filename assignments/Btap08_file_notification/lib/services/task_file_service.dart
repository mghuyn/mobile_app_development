import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class TaskFileService {
  Future<File> get _file async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/tasks.txt');
  }

  Future<List<Task>> load() async {
    try {
      final file = await _file;
      if (!await file.exists()) return [];
      return (await file.readAsString())
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .map(Task.fromString)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<Task> tasks) async {
    final file = await _file;
    await file.writeAsString(tasks.map((e) => e.toFileString()).join('\n'), flush: true);
  }
}
