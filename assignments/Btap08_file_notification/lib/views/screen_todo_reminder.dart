import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../services/file_service.dart';
import '../services/notification_service.dart';

class ScreenTodoReminder extends StatefulWidget {
  const ScreenTodoReminder({super.key});
  @override
  State<ScreenTodoReminder> createState() => _ScreenTodoReminderState();
}

class _ScreenTodoReminderState extends State<ScreenTodoReminder> {
  final controller = TextEditingController();
  final fileService = FileService();
  final todos = <Todo>[];
  DateTime? selectedTime;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final data = await fileService.loadTodos();
    if (!mounted) return;
    setState(() { todos..clear()..addAll(data); });
  }

  Future<void> _pick() async {
    final now = DateTime.now();
    final date = await showDatePicker(context: context, firstDate: DateTime(now.year, now.month, now.day), lastDate: DateTime(2100), initialDate: now);
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    setState(() => selectedTime = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _add() async {
    final title = controller.text.trim();
    final when = selectedTime;
    if (title.isEmpty || when == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nhập công việc và chọn thời gian')));
      return;
    }
    if (!when.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thời gian nhắc phải ở tương lai')));
      return;
    }

    final todo = Todo(title: title, time: when);
    setState(() => todos.add(todo));
    await fileService.saveTodos(todos);

    final id = when.millisecondsSinceEpoch.remainder(2147483647);
    await NotificationService.instance.schedule(id: id, title: 'Nhắc việc', body: title, at: when, channelId: 'todo_reminder_channel', channelName: 'Nhắc công việc');
    await NotificationService.instance.showSimple(id: id + 1, title: 'Đã thêm lịch', body: '$title - ${DateFormat('dd/MM/yyyy HH:mm').format(when)}', channelId: 'todo_added_channel', channelName: 'Thông báo Todo');

    controller.clear();
    if (!mounted) return;
    setState(() => selectedTime = null);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu công việc và thiết lập lịch nhắc')));
  }

  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo + Notification')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: controller, decoration: const InputDecoration(labelText: 'Tên công việc', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: Text(selectedTime == null ? 'Chưa chọn thời gian' : DateFormat('dd/MM/yyyy HH:mm').format(selectedTime!))),
            OutlinedButton(onPressed: _pick, child: const Text('Chọn thời gian')),
          ]),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _add, child: const Text('Lưu + đặt lịch')),
          const SizedBox(height: 16),
          Expanded(child: ListView.builder(itemCount: todos.length, itemBuilder: (_, i) => Card(child: ListTile(leading: const Icon(Icons.alarm), title: Text(todos[i].title), subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(todos[i].time))))))
        ]),
      ),
    );
  }
}
