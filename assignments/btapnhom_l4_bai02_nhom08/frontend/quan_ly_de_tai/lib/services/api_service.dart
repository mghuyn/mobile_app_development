import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/loai_do_an.dart';
import '../models/chuyen_nganh.dart';
import '../models/de_tai.dart';

class ApiService {
  static Future<dynamic> getJson(String endpoint) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Lỗi API: HTTP ${response.statusCode}');
    }

    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  static Future<List<LoaiDoAn>> getLoaiDoAn() async {
    final data = await getJson('/LoaiDoAn') as List;

    return data
        .map((e) => LoaiDoAn.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static Future<List<ChuyenNganh>> getChuyenNganh() async {
    final data = await getJson('/ChuyenNganh') as List;

    return data
        .map((e) => ChuyenNganh.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static Future<List<DeTai>> getDeTai({
    String? maLoaiDoAn,
    String? maChuyenNganh,
    String? keyword,
  }) async {
    final params = <String, String>{};

    if (maLoaiDoAn != null && maLoaiDoAn.isNotEmpty) {
      params['maLoaiDoAn'] = maLoaiDoAn;
    }

    if (maChuyenNganh != null && maChuyenNganh.isNotEmpty) {
      params['maChuyenNganh'] = maChuyenNganh;
    }

    if (keyword != null && keyword.trim().isNotEmpty) {
      params['keyword'] = keyword.trim();
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/DeTai')
        .replace(queryParameters: params.isEmpty ? null : params);

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Không thể tải đề tài: ${response.statusCode}');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;

    return data
        .map((e) => DeTai.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static Future<DeTai> getDeTaiById(String id) async {
    final data = await getJson('/DeTai/${Uri.encodeComponent(id)}');

    return DeTai.fromJson(Map<String, dynamic>.from(data as Map));
  }
}
