import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../services/notification_service.dart';
import '../../services/task_file_service.dart';
import 'add_task_screen.dart';

class HomeworkTodoScreen extends StatefulWidget {
  const HomeworkTodoScreen({super.key});
  @override
  State<HomeworkTodoScreen> createState() => _HomeworkTodoScreenState();
}

class _HomeworkTodoScreenState extends State<HomeworkTodoScreen> {
  final file = TaskFileService();
  List<Task> tasks = [];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final data = await file.load();
    if (!mounted) return;
    setState(() => tasks = data);
  }

  Future<void> _add() async {
    final task = await Navigator.push<Task>(context, MaterialPageRoute(builder: (_) => const AddTaskScreen()));
    if (task == null) return;
    tasks.add(task);
    await file.save(tasks);
    await NotificationService.instance.schedule(id: task.id, title: 'Nhắc nhiệm vụ', body: task.title, at: task.reminderTime, channelId: 'homework_todo', channelName: 'Nhiệm vụ mỗi ngày');
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _toggle(Task task, bool? checked) async {
    if (checked != true) return;
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('Xác nhận'), content: Text('Bạn xác nhận nhiệm vụ "${task.title}" đã hoàn thành?'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Không')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Có'))])) ?? false;
    if (!ok) return;
    task.completed = true;
    await NotificationService.instance.cancel(task.id);
    await file.save(tasks);
    final completedCount = tasks.where((e) => e.completed).length;
    await NotificationService.instance.showSimple(id: 900000 + completedCount, title: 'Hoàn thành nhiệm vụ', body: 'Bạn đã hoàn thành $completedCount nhiệm vụ.', channelId: 'completed_tasks', channelName: 'Hoàn thành nhiệm vụ');
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhiệm vụ mỗi ngày')),
      floatingActionButton: FloatingActionButton(onPressed: _add, child: const Icon(Icons.add)),
      body: tasks.isEmpty
          ? const Center(child: Text('Chưa có nhiệm vụ'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              itemBuilder: (_, i) {
                final t = tasks[i];
                return Card(
                  child: CheckboxListTile(
                    value: t.completed,
                    onChanged: t.completed ? null : (v) => _toggle(t, v),
                    secondary: const Icon(Icons.notifications_none),
                    title: Text(t.title, style: TextStyle(decoration: t.completed ? TextDecoration.lineThrough : null)),
                    subtitle: Text('Nhắc lúc: ${DateFormat('dd/MM/yyyy HH:mm').format(t.reminderTime)}'),
                  ),
                );
              },
            ),
    );
  }
}
