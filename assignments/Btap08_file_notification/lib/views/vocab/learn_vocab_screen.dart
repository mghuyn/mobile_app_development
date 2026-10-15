import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/vocabulary.dart';
import '../../services/notification_service.dart';
import '../../services/vocab_file_service.dart';

class LearnVocabScreen extends StatefulWidget {
  const LearnVocabScreen({super.key});
  @override
  State<LearnVocabScreen> createState() => _LearnVocabScreenState();
}

class _LearnVocabScreenState extends State<LearnVocabScreen> {
  final answer = TextEditingController();
  final service = VocabFileService();
  List<Vocabulary> items = [];
  Vocabulary? current;
  int correct = 0;
  int wrong = 0;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    items = await service.load();
    if (!mounted) return;
    setState(_next);
  }

  void _next() {
    if (items.isEmpty) { current = null; return; }
    current = items[Random().nextInt(items.length)];
    answer.clear();
  }

  Future<void> _check() async {
    if (current == null) return;
    final ok = answer.text.trim().toLowerCase() == current!.meaning.trim().toLowerCase();
    setState(() {
      if (ok) { correct++; } else { wrong++; }
    });
    if (!ok && wrong % 3 == 0) {
      await NotificationService.instance.showSimple(id: 3000 + wrong, title: 'Cần ôn tập', body: 'Bạn đã trả lời sai $wrong từ. Hãy ôn lại nhé!', channelId: 'vocab_wrong', channelName: 'Nhắc học từ');
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Chính xác!' : 'Sai rồi. Đáp án: ${current!.meaning}'), backgroundColor: ok ? Colors.green : Colors.red));
    setState(_next);
  }

  @override
  void dispose() { answer.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ôn tập từ mới')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Chip(label: Text('✓ $correct từ'), backgroundColor: Colors.green.shade200),
            Chip(label: Text('✕ $wrong từ'), backgroundColor: Colors.orange.shade200),
          ]),
          const SizedBox(height: 24),
          if (current == null)
            const Expanded(child: Center(child: Text('Chưa có từ vựng. Hãy thêm từ ở Trang chính.')))
          else
            Card(
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  Text(current!.word, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(controller: answer, decoration: const InputDecoration(hintText: 'Nhập nghĩa tiếng Việt', filled: true, fillColor: Colors.white, border: OutlineInputBorder())),
                  const SizedBox(height: 14),
                  ElevatedButton(onPressed: _check, child: const Text('Check')),
                ]),
              ),
            ),
        ]),
      ),
    );
  }
}
