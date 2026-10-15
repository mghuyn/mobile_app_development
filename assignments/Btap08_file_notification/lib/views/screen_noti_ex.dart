import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class ScreenNotiEx extends StatelessWidget {
  const ScreenNotiEx({super.key});

  Future<void> _run(BuildContext context, Future<void> Function() action, String message) async {
    try {
      await action();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = NotificationService.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Screen Noti Example')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () => _run(
                  context,
                  () => service.showSimple(id: 100, title: 'Nhắc học từ vựng', body: 'Bạn đã học 5 từ mới hôm nay chưa?', channelId: 'learn_english_channel', channelName: 'Học Anh Văn'),
                  'Đã gửi thông báo nhắc học Ngoại ngữ',
                ),
                child: const Text('Gửi thông báo nhắc học Ngoại ngữ'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _run(
                  context,
                  () => service.scheduleAfter(id: 101, delay: const Duration(minutes: 2), title: 'Uống nước', body: 'Nhắc uống nước đúng giờ', channelId: 'drink_water_channel', channelName: 'Uống nước'),
                  'Đã hẹn nhắc uống nước sau 2 phút',
                ),
                child: const Text('Gửi thông báo nhắc uống nước sau 2 phút'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _run(
                  context,
                  () => service.scheduleAfter(id: 102, delay: const Duration(minutes: 10), title: 'Nhắc học Ngoại ngữ', body: 'Đã đến giờ ôn lại từ vựng Ngoại ngữ!', channelId: 'learn_english_10_channel', channelName: 'Học Ngoại ngữ'),
                  'Đã hẹn nhắc học Ngoại ngữ sau 10 phút',
                ),
                child: const Text('Hẹn giờ gửi thông báo học Ngoại ngữ sau 10 phút', textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
