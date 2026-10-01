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
  static bool get supported => false;
  static Future<List<ContactItem>> getContacts() async => [];
  static Future<void> addContact({
    required String name, required String phone, required String email,
  }) async => throw UnsupportedError('Danh bạ chỉ hỗ trợ trên Android/iOS.');
}
