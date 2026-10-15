import 'package:flutter/material.dart';
import 'screen_noti_ex.dart';
import 'screen_todo.dart';
import 'screen_todo_reminder.dart';
import 'vocab/vocab_home_screen.dart';
import 'homework/homework_todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <({String title, String subtitle, IconData icon, Widget page})>[
      (title: 'Bài 1 - Local Notification', subtitle: 'Thông báo ngay, sau 2 phút, sau 10 phút', icon: Icons.notifications_active_outlined, page: const ScreenNotiEx()),
      (title: 'Bài 2 - Todo + File', subtitle: 'Lưu/đọc danh sách công việc từ todo.txt', icon: Icons.description_outlined, page: const ScreenTodo()),
      (title: 'Bài 3 - Todo + Notification', subtitle: 'Lưu công việc và hẹn thông báo theo thời gian chọn', icon: Icons.alarm_add_outlined, page: const ScreenTodoReminder()),
      (title: 'Bài 4 - Học từ vựng', subtitle: 'Lưu từ, học từ, kiểm tra từ, lịch nhắc', icon: Icons.school_outlined, page: const VocabHomeScreen()),
      (title: 'Bài về nhà - TodoList', subtitle: 'Thêm nhiệm vụ, đặt lịch, xác nhận hoàn thành', icon: Icons.task_alt_outlined, page: const HomeworkTodoScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Bài 08 - Notification và File'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final item = items[i];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              leading: CircleAvatar(child: Icon(item.icon)),
              title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item.page)),
            ),
          );
        },
      ),
    );
  }
}
