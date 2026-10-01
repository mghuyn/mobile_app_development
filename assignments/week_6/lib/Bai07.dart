import 'package:flutter/material.dart';
import 'sms_service.dart';

class Bai7 extends StatefulWidget {
  const Bai7({super.key});
  @override
  State<Bai7> createState() => _Bai7State();
}

class _Bai7State extends State<Bai7> {
  List<SmsItem> all = [];
  String senderFilter = '';
  DateTime? selectedMonth;
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { loading = true; error = ''; });
    if (!SmsService.supported) {
      setState(() {
        loading = false;
        error = 'SMS Analyzer chỉ có dữ liệu SMS hệ thống trên Android. '
            'Windows/Web vẫn mở được ứng dụng nhưng không có SMS hệ thống.';
      });
      return;
    }
    try {
      all = await SmsService.getInbox();
    } catch (e) {
      error = '$e';
    }
    if (mounted) setState(() => loading = false);
  }

  List<SmsItem> get filtered {
    return all.where((sms) {
      final bySender = senderFilter.trim().isEmpty ||
          sms.address.contains(senderFilter.trim());
      final byMonth = selectedMonth == null ||
          (sms.date.year == selectedMonth!.year &&
           sms.date.month == selectedMonth!.month);
      return bySender && byMonth;
    }).toList();
  }

  List<SmsItem> get qc => filtered.where((s) =>
      s.body.trim().toUpperCase().startsWith('[QC]')).toList();

  List<SmsItem> get otp => filtered.where((s) =>
      RegExp(r'^\[OTP\]\s*\d{6}\b', caseSensitive: false)
          .hasMatch(s.body.trim())).toList();

  String? extractOtp(String body) {
    final match = RegExp(r'\[OTP\]\s*(\d{6})\b', caseSensitive: false)
        .firstMatch(body.trim());
    return match?.group(1);
  }

  Map<String, int> get byMonth {
    final result = <String, int>{};
    for (final sms in all) {
      final key = '${sms.date.month.toString().padLeft(2, '0')}/${sms.date.year}';
      result[key] = (result[key] ?? 0) + 1;
    }
    return result;
  }

  Map<String, int> get byDay {
    final result = <String, int>{};
    for (final sms in filtered) {
      final key = '${sms.date.day.toString().padLeft(2, '0')}/'
          '${sms.date.month.toString().padLeft(2, '0')}/${sms.date.year}';
      result[key] = (result[key] ?? 0) + 1;
    }
    return result;
  }

  Future<void> _chooseMonth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
      helpText: 'Chọn tháng cần thống kê',
    );
    if (picked != null) {
      setState(() => selectedMonth = DateTime(picked.year, picked.month));
    }
  }

  void _showOtp(SmsItem sms) {
    final code = extractOtp(sms.body);
    if (code == null) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mã OTP'),
        content: SelectableText(
          code,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
            child: const Text('Đóng')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = filtered;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 7 - SMS Analyzer'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: _chooseMonth, icon: const Icon(Icons.calendar_month)),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(error, textAlign: TextAlign.center)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Lọc theo số điện thoại',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => setState(() => senderFilter = v),
                      ),
                      const SizedBox(height: 10),
                      if (selectedMonth != null)
                        Row(children: [
                          Chip(label: Text(
                            'Tháng ${selectedMonth!.month}/${selectedMonth!.year}')),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => setState(() => selectedMonth = null),
                            child: const Text('Bỏ lọc tháng')),
                        ]),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: [
                          _stat('Tổng SMS', data.length.toString()),
                          _stat('QC', qc.length.toString()),
                          _stat('OTP', otp.length.toString()),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text('Thống kê theo tháng',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      if (byMonth.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Không có dữ liệu.'))
                      else
                        ...byMonth.entries.map((e) => ListTile(
                          dense: true,
                          title: Text(e.key),
                          trailing: Text('${e.value} SMS'),
                        )),
                      const SizedBox(height: 10),
                      const Text('Thống kê theo ngày',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      if (byDay.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Không có dữ liệu.'))
                      else
                        ...byDay.entries.map((e) => ListTile(
                          dense: true,
                          title: Text(e.key),
                          trailing: Text('${e.value} SMS'),
                        )),
                      const SizedBox(height: 18),
                      const Text('Tin nhắn QC',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ...qc.map(_smsTile),
                      const SizedBox(height: 18),
                      const Text('Tin nhắn OTP',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ...otp.map(_smsTile),
                      const SizedBox(height: 18),
                      const Text('Tất cả tin nhắn',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ...data.map(_smsTile),
                    ],
                  ),
                ),
    );
  }

  Widget _stat(String title, String value) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(title),
      ]),
    ),
  );

  Widget _smsTile(SmsItem sms) {
    final code = extractOtp(sms.body);
    return Card(
      child: ListTile(
        leading: Icon(code != null ? Icons.password : Icons.sms),
        title: Text(sms.address),
        subtitle: Text(
          '${sms.date.day.toString().padLeft(2, '0')}/'
          '${sms.date.month.toString().padLeft(2, '0')}/${sms.date.year} '
          '${sms.date.hour.toString().padLeft(2, '0')}:'
          '${sms.date.minute.toString().padLeft(2, '0')}\n${sms.body}',
        ),
        isThreeLine: true,
        onTap: code == null ? null : () => _showOtp(sms),
      ),
    );
  }
}
