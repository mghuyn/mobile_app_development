class DeTai {
  final String maDeTai;
  final String tenDeTai;
  final int soSinhVienToiDa;
  final String tenLoaiDoAn;
  final String tenChuyenNganh;
  final String giangVienHuongDan;
  final String yeuCau;
  final String moTa;
  final String hocVi;

  const DeTai({
    required this.maDeTai,
    required this.tenDeTai,
    required this.soSinhVienToiDa,
    required this.tenLoaiDoAn,
    required this.tenChuyenNganh,
    required this.giangVienHuongDan,
    required this.yeuCau,
    required this.moTa,
    required this.hocVi,
  });

  factory DeTai.fromJson(Map<String, dynamic> json) {
    return DeTai(
      maDeTai: json['maDeTai']?.toString() ?? '',
      tenDeTai: json['tenDeTai']?.toString() ?? '',
      soSinhVienToiDa: (json['soSinhVienToiDa'] as num?)?.toInt() ?? 0,
      tenLoaiDoAn: json['tenLoaiDoAn']?.toString() ?? '',
      tenChuyenNganh: json['tenChuyenNganh']?.toString() ?? '',
      giangVienHuongDan: json['giangVienHuongDan']?.toString() ?? '',
      yeuCau: json['yeuCau']?.toString() ?? '',
      moTa: json['moTa']?.toString() ?? '',
      hocVi: json['hocVi']?.toString() ?? '',
    );
  }
}
