import 'package:flutter/material.dart';
import '../../services/notification_service.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});
  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  var items = <dynamic>[];
  bool loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final data = await NotificationService.instance.pending();
    if (!mounted) return;
    setState(() { items = data; loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch nhắc')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(child: Text('Không có lịch nhắc đang chờ'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(item.title ?? 'Lịch nhắc'),
                      subtitle: Text(item.body ?? ''),
                      trailing: IconButton(icon: const Icon(Icons.cancel, color: Colors.red), onPressed: () async { await NotificationService.instance.cancel(item.id); await _load(); }),
                    );
                  },
                ),
    );
  }
}
