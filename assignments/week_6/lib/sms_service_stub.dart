class SmsItem {
  final String address;
  final String body;
  final DateTime date;
  const SmsItem({required this.address, required this.body, required this.date});
}

class SmsService {
  static bool get supported => false;
  static Future<List<SmsItem>> getInbox() async => [];
}
