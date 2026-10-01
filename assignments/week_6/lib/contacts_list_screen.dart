import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'contact_service.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});
  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  List<ContactItem> contacts = [];
  bool loading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!ContactService.supported) {
      setState(() { loading = false; error = 'Chức năng danh bạ chỉ chạy trên Android/iOS.'; });
      return;
    }
    setState(() { loading = true; error = ''; });
    try {
      contacts = await ContactService.getContacts();
    } catch (e) {
      error = '$e';
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> _add() async {
    if (!ContactService.supported) return;
    final result = await Navigator.push(
      context, MaterialPageRoute(builder: (_) => const AddContactPage()));
    if (result == true) _load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Bài 5 - Quản lý danh bạ'),
      actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))],
    ),
    floatingActionButton: ContactService.supported
        ? FloatingActionButton(onPressed: _add, child: const Icon(Icons.add))
        : null,
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : error.isNotEmpty
            ? Center(child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(error, textAlign: TextAlign.center)))
            : contacts.isEmpty
                ? const Center(child: Text('Không có liên hệ nào.'))
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (_, i) {
                      final c = contacts[i];
                      return ListTile(
                        leading: c.avatar != null
                            ? CircleAvatar(backgroundImage: MemoryImage(
                                Uint8List.fromList(c.avatar!)))
                            : const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(c.name),
                        subtitle: Text('${c.phone}\n${c.email}'),
                        isThreeLine: true,
                      );
                    }),
  );
}

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});
  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();

  @override
  void dispose() {
    name.dispose(); phone.dispose(); email.dispose(); super.dispose();
  }

  Future<void> _save() async {
    if (name.text.trim().isEmpty || phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tên và số điện thoại không được để trống.')));
      return;
    }
    try {
      await ContactService.addContact(
        name: name.text.trim(), phone: phone.text.trim(), email: email.text.trim());
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể lưu: $e')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Thêm danh bạ')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextField(controller: name, decoration: const InputDecoration(
          labelText: 'Họ và tên', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: phone, keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: 'Số điện thoại',
            border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: email, keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email',
            border: OutlineInputBorder())),
        const SizedBox(height: 20),
        FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save),
          label: const Text('Lưu vào danh bạ điện thoại')),
      ],
    ),
  );
}
