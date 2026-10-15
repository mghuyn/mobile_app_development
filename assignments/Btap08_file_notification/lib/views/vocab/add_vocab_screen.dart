import 'package:flutter/material.dart';
import '../../models/vocabulary.dart';
import '../../services/notification_service.dart';
import '../../services/vocab_file_service.dart';

class AddVocabScreen extends StatefulWidget {
  final bool embedded;
  const AddVocabScreen({super.key, this.embedded = false});
  @override
  State<AddVocabScreen> createState() => _AddVocabScreenState();
}

class _AddVocabScreenState extends State<AddVocabScreen> {
  final wordController = TextEditingController();
  final meaningController = TextEditingController();
  final service = VocabFileService();

  Future<void> _save() async {
    final word = wordController.text.trim();
    final meaning = meaningController.text.trim();
    if (word.isEmpty || meaning.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nhập đầy đủ từ và nghĩa')));
      return;
    }
    await service.add(Vocabulary(word: word, meaning: meaning));
    final id = DateTime.now().millisecondsSinceEpoch.remainder(2147483647);
    await NotificationService.instance.showSimple(id: id, title: 'Đã lưu từ mới', body: '$word - hãy ôn tập sau 10 phút', channelId: 'vocab_saved', channelName: 'Học từ vựng');
    await NotificationService.instance.scheduleAfter(id: id + 1, delay: const Duration(minutes: 10), title: 'Ôn từ vựng', body: 'Hãy ôn lại từ "$word"', channelId: 'vocab_reminder', channelName: 'Lịch ôn từ');
    wordController.clear();
    meaningController.clear();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu và lên lịch nhắc học từ sau 10 phút')));
  }

  @override
  void dispose() { wordController.dispose(); meaningController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: wordController, decoration: const InputDecoration(labelText: 'Từ', border: UnderlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: meaningController, decoration: const InputDecoration(labelText: 'Nghĩa', border: UnderlineInputBorder())),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: _save, child: const Text('Lưu & Nhắc học sau 10 phút')),
      ]),
    );
    if (widget.embedded) return content;
    return Scaffold(appBar: AppBar(title: const Text('Thêm từ vựng')), body: content);
  }
}
