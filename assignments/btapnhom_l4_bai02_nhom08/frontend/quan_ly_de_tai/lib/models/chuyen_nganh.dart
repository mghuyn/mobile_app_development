class ChuyenNganh {
  final String maChuyenNganh;
  final String tenChuyenNganh;
  final String? moTa;

  const ChuyenNganh({
    required this.maChuyenNganh,
    required this.tenChuyenNganh,
    this.moTa,
  });

  factory ChuyenNganh.fromJson(Map<String, dynamic> json) {
    return ChuyenNganh(
      maChuyenNganh: json['maChuyenNganh']?.toString() ?? '',
      tenChuyenNganh: json['tenChuyenNganh']?.toString() ?? '',
      moTa: json['moTa']?.toString(),
    );
  }
}
