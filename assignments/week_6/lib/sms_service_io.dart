import 'dart:io';
import 'package:another_telephony/telephony.dart';

class SmsItem {
  final String address;
  final String body;
  final DateTime date;
  const SmsItem({required this.address, required this.body, required this.date});
}

class SmsService {
  static bool get supported => Platform.isAndroid;

  static Future<List<SmsItem>> getInbox() async {
    if (!supported) return [];
    final telephony = Telephony.instance;
    final granted = await telephony.requestSmsPermissions;
    if (granted != true) throw Exception('Chưa cấp quyền đọc SMS.');
    final messages = await telephony.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
    );
    return messages.map((m) => SmsItem(
      address: m.address ?? 'Không xác định',
      body: m.body ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(m.date ?? 0),
    )).toList();
  }
}
