import 'package:flutter/material.dart';
import 'add_vocab_screen.dart';
import 'learn_vocab_screen.dart';
import 'quiz_vocab_screen.dart';
import 'reminder_list_screen.dart';

class VocabHomeScreen extends StatelessWidget {
  const VocabHomeScreen({super.key});

  void _open(BuildContext context, Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ứng dụng học từ vựng')),
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(decoration: BoxDecoration(color: Colors.blue), child: Align(alignment: Alignment.bottomLeft, child: Text('Trợ lý học từ vựng', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)))),
          ListTile(leading: const Icon(Icons.home), title: const Text('Trang chính'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.list), title: const Text('Học từ'), onTap: () { Navigator.pop(context); _open(context, const LearnVocabScreen()); }),
          ListTile(leading: const Icon(Icons.quiz), title: const Text('Kiểm tra từ'), onTap: () { Navigator.pop(context); _open(context, const QuizVocabScreen()); }),
          ListTile(leading: const Icon(Icons.notifications), title: const Text('Lịch nhắc'), onTap: () { Navigator.pop(context); _open(context, const ReminderListScreen()); }),
        ]),
      ),
      body: const AddVocabScreen(embedded: true),
    );
  }
}
