import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../services/file_service.dart';

class ScreenTodo extends StatefulWidget {
  const ScreenTodo({super.key});
  @override
  State<ScreenTodo> createState() => _ScreenTodoState();
}

class _ScreenTodoState extends State<ScreenTodo> {
  final controller = TextEditingController();
  final fileService = FileService();
  final todos = <Todo>[];
  DateTime? selectedTime;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await fileService.loadTodos();
    if (!mounted) return;
    setState(() { todos..clear()..addAll(data); });
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(context: context, firstDate: DateTime(now.year, now.month, now.day), lastDate: DateTime(2100), initialDate: now);
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    setState(() => selectedTime = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _add() async {
    final title = controller.text.trim();
    if (title.isEmpty || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hãy nhập tên công việc và chọn thời gian')));
      return;
    }
    setState(() => todos.add(Todo(title: title, time: selectedTime!)));
    await fileService.saveTodos(todos);
    controller.clear();
    setState(() => selectedTime = null);
  }

  String _format(DateTime time) => DateFormat('dd/MM/yyyy HH:mm').format(time);

  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final colors = [Colors.red.shade100, Colors.green.shade100, Colors.blue.shade100, Colors.yellow.shade100, Colors.purple.shade100];
    return Scaffold(
      appBar: AppBar(title: const Text('Todo App'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: controller, decoration: const InputDecoration(labelText: 'Tên công việc', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: Text(selectedTime == null ? 'Chưa chọn thời gian' : _format(selectedTime!))),
            OutlinedButton(onPressed: _pickDateTime, child: const Text('Chọn thời gian')),
          ]),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: _add, child: const Text('Lưu')),
          const SizedBox(height: 20),
          Expanded(
            child: todos.isEmpty
                ? const Center(child: Text('Chưa có công việc'))
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (_, i) {
                      final t = todos[i];
                      return Card(color: colors[i % colors.length], child: ListTile(leading: const Icon(Icons.task), title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(_format(t.time))));
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}
