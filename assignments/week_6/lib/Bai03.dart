import 'package:flutter/material.dart';
import 'contact_service.dart';
import 'sms_service.dart';

class Bai3 extends StatelessWidget {
  const Bai3({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Bài 3 - Danh bạ & SMS')),
    body: Center(
      child: Wrap(
        spacing: 12, runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.contacts),
            label: const Text('Đọc danh bạ'),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ContactsReaderPage())),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.sms),
            label: const Text('Đọc SMS'),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SmsReaderPage())),
          ),
        ],
      ),
    ),
  );
}

class ContactsReaderPage extends StatefulWidget {
  const ContactsReaderPage({super.key});
  @override
  State<ContactsReaderPage> createState() => _ContactsReaderPageState();
}
class _ContactsReaderPageState extends State<ContactsReaderPage> {
  List<ContactItem> contacts = [];
  bool loading = true;
  String error = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { loading = true; error = ''; });
    if (!ContactService.supported) {
      setState(() {
        loading = false;
        error = 'Danh bạ thiết bị chỉ hỗ trợ trên Android/iOS. Windows và Web không có API danh bạ hệ thống.';
      });
      return;
    }
    try {
      contacts = await ContactService.getContacts();
    } catch (e) {
      error = '$e';
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Danh bạ'), actions: [
      IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
    ]),
    body: loading ? const Center(child: CircularProgressIndicator())
        : error.isNotEmpty ? Center(child: Padding(
            padding: const EdgeInsets.all(20), child: Text(error, textAlign: TextAlign.center)))
        : contacts.isEmpty ? const Center(child: Text('Không có danh bạ.'))
        : ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (_, i) {
              final c = contacts[i];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(c.name),
                subtitle: Text(c.phone),
              );
            }),
  );
}

class SmsReaderPage extends StatefulWidget {
  const SmsReaderPage({super.key});
  @override
  State<SmsReaderPage> createState() => _SmsReaderPageState();
}
class _SmsReaderPageState extends State<SmsReaderPage> {
  List<SmsItem> messages = [];
  bool loading = true;
  String error = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { loading = true; error = ''; });
    if (!SmsService.supported) {
      setState(() {
        loading = false;
        error = 'Đọc SMS là chức năng Android-only. Windows và Web vẫn chạy app nhưng không có SMS hệ thống.';
      });
      return;
    }
    try {
      messages = await SmsService.getInbox();
    } catch (e) {
      error = '$e';
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tin nhắn SMS'), actions: [
      IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
    ]),
    body: loading ? const Center(child: CircularProgressIndicator())
        : error.isNotEmpty ? Center(child: Padding(
            padding: const EdgeInsets.all(20), child: Text(error, textAlign: TextAlign.center)))
        : messages.isEmpty ? const Center(child: Text('Không có SMS.'))
        : ListView.builder(
            itemCount: messages.length,
            itemBuilder: (_, i) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.sms)),
              title: Text(messages[i].address),
              subtitle: Text(messages[i].body),
            )),
  );
}
