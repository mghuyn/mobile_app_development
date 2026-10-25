import 'package:flutter/material.dart';

import '../models/de_tai.dart';
import '../services/api_service.dart';

class DeTaiDetailScreen extends StatefulWidget {
  final String maDeTai;

  const DeTaiDetailScreen({super.key, required this.maDeTai});

  @override
  State<DeTaiDetailScreen> createState() => _DeTaiDetailScreenState();
}

class _DeTaiDetailScreenState extends State<DeTaiDetailScreen> {
  late Future<DeTai> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.getDeTaiById(widget.maDeTai);
  }

  List<String> _tachYeuCau(String text) {
    final lines = text
        .split(RegExp(r'[\r\n]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (lines.isEmpty) return ['Chưa cập nhật yêu cầu đề tài'];

    return lines.map((e) {
      if (e.startsWith('-') || e.startsWith('•')) {
        return e.substring(1).trim();
      }
      return e;
    }).toList();
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF4A86F7)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF333333),
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: value.isEmpty ? 'Chưa cập nhật' : value,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(DeTai dt) {
    final yeuCauList = _tachYeuCau(dt.yeuCau);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F2F7),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Mã đề tài: ${dt.maDeTai}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF9A9A9A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Tên đề tài: ${dt.tenDeTai}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2196F3),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFD3CCD3), thickness: 1),
              const SizedBox(height: 16),

              _buildInfoRow(
                Icons.groups_2,
                'Số lượng SV tối đa',
                '${dt.soSinhVienToiDa.toString().padLeft(2, '0')} sinh viên',
              ),
              _buildInfoRow(Icons.school, 'Chuyên ngành', dt.tenChuyenNganh),
              _buildInfoRow(
                Icons.person,
                'Giảng viên hướng dẫn',
                '${dt.hocVi} ${dt.giangVienHuongDan}'.trim(),
              ),

              const SizedBox(height: 10),
              const Text(
                'Yêu cầu đề tài:',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: yeuCauList.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '- $item',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF555555),
                          height: 1.5,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EDF4),
      appBar: AppBar(
        title: const Text(
          'Thông tin Đề tài Đồ án',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFF4A86F7),
        elevation: 0,
      ),
      body: FutureBuilder<DeTai>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Không tải được chi tiết đề tài',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _future = ApiService.getDeTaiById(widget.maDeTai);
                        });
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy đề tài'));
          }

          return SingleChildScrollView(child: _buildDetailCard(snapshot.data!));
        },
      ),
    );
  }
}
