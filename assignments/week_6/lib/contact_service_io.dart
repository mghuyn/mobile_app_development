import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactItem {
  final String name;
  final String phone;
  final String email;
  final List<int>? avatar;
  const ContactItem({
    required this.name, required this.phone, required this.email, this.avatar,
  });
}

class ContactService {
  static bool get supported => Platform.isAndroid || Platform.isIOS;

  static Future<List<ContactItem>> getContacts() async {
    if (!supported) return [];
    final permission = await Permission.contacts.request();
    if (!permission.isGranted) throw Exception('Chưa cấp quyền danh bạ.');
    final list = await FlutterContactsService.getContacts(withThumbnails: true);
    return list.map((c) => ContactItem(
      name: c.displayName ?? 'Không có tên',
      phone: (c.phones ?? const <ValueItem>[]).isNotEmpty ? ((c.phones ?? const <ValueItem>[]).first.value ?? '') : 'Không có số',
      email: (c.emails ?? const <ValueItem>[]).isNotEmpty ? ((c.emails ?? const <ValueItem>[]).first.value ?? '') : 'Không có email',
      avatar: c.avatar,
    )).toList();
  }

  static Future<void> addContact({
    required String name, required String phone, required String email,
  }) async {
    if (!supported) throw UnsupportedError('Danh bạ chỉ hỗ trợ trên Android/iOS.');
    final permission = await Permission.contacts.request();
    if (!permission.isGranted) throw Exception('Chưa cấp quyền danh bạ.');
    final contact = ContactInfo(
      displayName: name,
      phones: [ValueItem(label: 'mobile', value: phone)],
      emails: email.isEmpty ? [] : [ValueItem(label: 'email', value: email)],
    );
    await FlutterContactsService.addContact(contact);
  }
}
