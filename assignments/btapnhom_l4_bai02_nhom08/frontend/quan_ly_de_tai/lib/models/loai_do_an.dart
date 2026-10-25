class LoaiDoAn {
  final String maLoaiDoAn;
  final String tenLoaiDoAn;
  final String? moTa;

  const LoaiDoAn({
    required this.maLoaiDoAn,
    required this.tenLoaiDoAn,
    this.moTa,
  });

  factory LoaiDoAn.fromJson(Map<String, dynamic> json) {
    return LoaiDoAn(
      maLoaiDoAn: json['maLoaiDoAn']?.toString() ?? '',
      tenLoaiDoAn: json['tenLoaiDoAn']?.toString() ?? '',
      moTa: json['moTa']?.toString(),
    );
  }
}
