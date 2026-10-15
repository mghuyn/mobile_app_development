import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final controller = TextEditingController();
  DateTime? reminder;

  Future<void> _pick() async {
    final now = DateTime.now();
    final date = await showDatePicker(context: context, firstDate: DateTime(now.year, now.month, now.day), lastDate: DateTime(2100), initialDate: now);
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    setState(() => reminder = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  void _save() {
    final title = controller.text.trim();
    if (title.isEmpty || reminder == null || !reminder!.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nhập tên nhiệm vụ và chọn giờ nhắc ở tương lai')));
      return;
    }
    final id = DateTime.now().millisecondsSinceEpoch.remainder(2147483647);
    Navigator.pop(context, Task(id: id, title: title, reminderTime: reminder!));
  }

  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm nhiệm vụ mới')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: controller, decoration: const InputDecoration(labelText: 'Tên nhiệm vụ', border: OutlineInputBorder())),
          const SizedBox(height: 14),
          InkWell(onTap: _pick, child: InputDecorator(decoration: const InputDecoration(labelText: 'Giờ nhắc', border: OutlineInputBorder()), child: Text(reminder == null ? 'Chọn thời gian' : DateFormat('dd/MM/yyyy HH:mm').format(reminder!)))),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _save, child: const Text('Lưu nhiệm vụ')),
        ]),
      ),
    );
  }
}
