import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/vocabulary.dart';
import '../../services/vocab_file_service.dart';

class QuizVocabScreen extends StatefulWidget {
  const QuizVocabScreen({super.key});
  @override
  State<QuizVocabScreen> createState() => _QuizVocabScreenState();
}

class _QuizVocabScreenState extends State<QuizVocabScreen> {
  List<Vocabulary> source = [];
  List<Vocabulary> questions = [];
  int index = 0, correct = 0, wrong = 0;
  Vocabulary? current;
  bool loading = true;

  @override
  void initState() { super.initState(); _start(); }

  Future<void> _start() async {
    source = await VocabFileService().load();
    source.shuffle(Random());
    questions = List.of(source);
    if (!mounted) return;
    setState(() { loading = false; current = questions.isEmpty ? null : questions.first; });
  }

  Future<void> _answer(bool saysCorrect) async {
    if (current == null) return;
    final statementTrue = Random().nextBool();
    final shownMeaning = statementTrue || source.length < 2
        ? current!.meaning
        : (source.where((e) => e.meaning != current!.meaning).toList()..shuffle()).first.meaning;
    // Hiển thị hộp xác nhận cho câu vừa chấm để tránh ẩn logic.
    final userRight = saysCorrect == statementTrue;
    if (userRight) { correct++; } else { wrong++; }
    index++;
    if (index >= questions.length) {
      final total = correct + wrong;
      final ratio = total == 0 ? 0.0 : correct * 100 / total;
      if (!mounted) return;
      await showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Kết thúc kiểm tra'), content: Text('Tổng số câu: $total\n✓ Đúng: $correct\n✕ Sai: $wrong\nTỷ lệ đúng: ${ratio.toStringAsFixed(1)}%'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng'))]));
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }
    setState(() => current = questions[index]);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (current == null) return Scaffold(appBar: AppBar(title: const Text('Trắc nghiệm Đúng / Sai')), body: const Center(child: Text('Chưa có dữ liệu từ vựng.')));

    // Tạo phát biểu cố định theo index để UI không đổi khi setState.
    final random = Random(current!.word.hashCode ^ index);
    final statementTrue = random.nextBool() || source.length < 2;
    final alternatives = source.where((e) => e.meaning != current!.meaning).toList();
    final shownMeaning = statementTrue || alternatives.isEmpty ? current!.meaning : alternatives[random.nextInt(alternatives.length)].meaning;

    void answer(bool saysCorrect) async {
      final userRight = saysCorrect == statementTrue;
      setState(() { if (userRight) { correct++; } else { wrong++; } index++; });
      if (index >= questions.length) {
        final total = correct + wrong;
        final ratio = total == 0 ? 0.0 : correct * 100 / total;
        await showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Kết thúc kiểm tra'), content: Text('Tổng số câu: $total\n✓ Đúng: $correct\n✕ Sai: $wrong\nTỷ lệ đúng: ${ratio.toStringAsFixed(1)}%'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng'))]));
        if (context.mounted) Navigator.pop(context);
      } else {
        setState(() => current = questions[index]);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Trắc nghiệm Đúng / Sai')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Chip(label: Text('Đúng: $correct')), Chip(label: Text('Sai: $wrong'))]),
          const Spacer(),
          Text(current!.word, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(shownMeaning, style: const TextStyle(fontSize: 20)),
          const Spacer(),
          Row(children: [
            Expanded(child: ElevatedButton.icon(onPressed: () => answer(true), icon: const Icon(Icons.check), label: const Text('Đúng'))),
            const SizedBox(width: 16),
            Expanded(child: ElevatedButton.icon(onPressed: () => answer(false), icon: const Icon(Icons.close), label: const Text('Sai'))),
          ]),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }
}
