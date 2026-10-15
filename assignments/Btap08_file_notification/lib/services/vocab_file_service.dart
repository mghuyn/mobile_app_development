import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/vocabulary.dart';

class VocabFileService {
  Future<File> get _file async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/vocab.txt');
  }

  Future<List<Vocabulary>> load() async {
    try {
      final file = await _file;
      if (!await file.exists()) return [];
      return (await file.readAsString())
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .map(Vocabulary.fromString)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> add(Vocabulary item) async {
    final file = await _file;
    await file.writeAsString('${item.toFileString()}\n', mode: FileMode.append, flush: true);
  }
}
