import 'package:flutter/material.dart';

import '../models/loai_do_an.dart';
import '../models/chuyen_nganh.dart';
import '../models/de_tai.dart';
import '../services/api_service.dart';
import 'de_tai_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color orange = Color(0xFFF6A800);
  static const Color purple = Color(0xFF5147E9);
  static const Color ink = Color(0xFF202020);

  final TextEditingController _searchController = TextEditingController();

  List<LoaiDoAn> _loaiDoAn = [];
  List<ChuyenNganh> _chuyenNganh = [];
  List<DeTai> _deTai = [];

  String? _selectedLoai = 'DA';
  String? _selectedNganh;

  bool _loading = true;
  bool _showSearch = false;
  String? _error;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _requestId++;
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final currentRequest = ++_requestId;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await Future.wait<dynamic>([
        ApiService.getLoaiDoAn(),
        ApiService.getChuyenNganh(),
      ]);

      if (!mounted || currentRequest != _requestId) return;

      setState(() {
        _loaiDoAn = results[0] as List<LoaiDoAn>;
        _chuyenNganh = results[1] as List<ChuyenNganh>;
      });

      await _loadDeTai();
    } catch (e) {
      if (!mounted || currentRequest != _requestId) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadDeTai() async {
    final currentRequest = ++_requestId;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await ApiService.getDeTai(
        maLoaiDoAn: _selectedLoai,
        maChuyenNganh: _selectedNganh,
        keyword: _searchController.text.trim(),
      );

      if (!mounted || currentRequest != _requestId) return;

      setState(() {
        _deTai = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted || currentRequest != _requestId) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: orange,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.school_outlined, color: Colors.black, size: 27),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Quản lý đề tài đồ án',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ink,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Tìm kiếm',
                onPressed: () {
                  setState(() {
                    _showSearch = !_showSearch;
                    if (!_showSearch) {
                      _searchController.clear();
                    }
                  });
                  if (!_showSearch) _loadDeTai();
                },
                icon: Icon(
                  _showSearch ? Icons.close : Icons.search,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2CC),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KHÁM PHÁ ĐỀ TÀI',
                  style: TextStyle(
                    color: Color(0xFF795017),
                    fontSize: 13,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Danh sách đề tài',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: ink,
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  'Tìm kiếm đề tài phù hợp với chuyên ngành của bạn',
                  style: TextStyle(fontSize: 14, color: Color(0xFF76551E)),
                ),
              ],
            ),
          ),
          if (_showSearch) ...[
            const SizedBox(height: 13),
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _loadDeTai(),
              decoration: InputDecoration(
                hintText: 'Nhập tên đề tài...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _loadDeTai,
                  icon: const Icon(Icons.arrow_forward),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoaiDoAn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn loại đồ án',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 13),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _loaiDoAn.map((item) {
              final selected = _selectedLoai == item.maLoaiDoAn;

              return Padding(
                padding: const EdgeInsets.only(right: 9),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    setState(() {
                      _selectedLoai = selected ? null : item.maLoaiDoAn;
                    });
                    _loadDeTai();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? purple : const Color(0xFFF0EEFC),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      item.tenLoaiDoAn,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF49428C),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  IconData _getNganhIcon(String ma) {
    switch (ma.toUpperCase()) {
      case 'CNPM':
        return Icons.code_rounded;
      case 'HTTT':
        return Icons.storage_rounded;
      case 'MMT':
        return Icons.network_check_rounded;
      case 'ATTT':
        return Icons.shield_outlined;
      case 'AI':
        return Icons.psychology_outlined;
      default:
        return Icons.menu_book_outlined;
    }
  }

  Color _getNganhColor(String ma) {
    switch (ma.toUpperCase()) {
      case 'CNPM':
        return const Color(0xFF5147E9);
      case 'HTTT':
        return const Color(0xFF008BCB);
      case 'MMT':
        return const Color(0xFF059B76);
      case 'ATTT':
        return const Color(0xFFE38C24);
      default:
        return const Color(0xFFB652AC);
    }
  }

  Widget _buildChuyenNganh() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chuyên ngành thực hiện',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),
        ..._chuyenNganh.map((item) {
          final selected = _selectedNganh == item.maChuyenNganh;

          return Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Material(
              color: selected
                  ? const Color(0xFFEAE8FF)
                  : const Color(0xFFF6F6FA),
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  setState(() {
                    _selectedNganh = selected ? null : item.maChuyenNganh;
                  });
                  _loadDeTai();
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: selected ? Border.all(color: purple) : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          color: _getNganhColor(item.maChuyenNganh),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(
                          _getNganhIcon(item.maChuyenNganh),
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.tenChuyenNganh,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ink,
                              ),
                            ),
                            if (item.moTa != null && item.moTa!.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Text(
                                item.moTa!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF837A8C),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        selected ? Icons.check_circle : Icons.chevron_right,
                        color: selected ? purple : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDeTai() {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Column(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 42, color: Colors.grey),
          const SizedBox(height: 10),
          Text('Không tải được dữ liệu:\n$_error', textAlign: TextAlign.center),
          const SizedBox(height: 8),
          TextButton(onPressed: _loadInitialData, child: const Text('Thử lại')),
        ],
      );
    }

    if (_deTai.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(25),
        child: Center(child: Text('Không tìm thấy đề tài phù hợp.')),
      );
    }

    return Column(
      children: _deTai.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: const Color(0xFFF6F6FA),
            borderRadius: BorderRadius.circular(15),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              title: Text(
                item.tenDeTai,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ink,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Text(
                  '${item.maDeTai} • ${item.tenChuyenNganh}\n'
                  'GVHD: ${item.hocVi.isNotEmpty ? '${item.hocVi} ' : ''}${item.giangVienHuongDan}\n'
                  'Tối đa ${item.soSinhVienToiDa} sinh viên',
                  style: const TextStyle(fontSize: 13, height: 1.6),
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: purple),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeTaiDetailScreen(maDeTai: item.maDeTai),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadInitialData,
          child: ListView(
            children: [
              _buildHeader(),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 780),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 20, 14, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLoaiDoAn(),
                        const SizedBox(height: 24),
                        _buildChuyenNganh(),
                        const SizedBox(height: 17),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Danh sách đề tài',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (!_loading)
                              Text(
                                '${_deTai.length} đề tài',
                                style: const TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _buildDeTai(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
