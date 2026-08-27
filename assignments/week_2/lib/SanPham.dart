class SanPham {
  String _maSP = '';
  String _tenSP = '';
  double _donGia = 0;
  double _giamGia = 0;

  // Constructor mặc định
  SanPham() {
    _maSP = "SP000";
    _tenSP = "Unknown";
    _donGia = 0;
    _giamGia = 0;
  }

  // Constructor đầy đủ tham số
  SanPham.fullPara(String masp, String tensp, double gia, double giam) {
    _maSP = masp;
    _tenSP = tensp;
    _donGia = gia;
    _giamGia = giam;
  }

  // Getters & Setters
  String get maSP => _maSP;
  set maSP(String value) {
    if (value.isNotEmpty) _maSP = value;
  }

  String get tenSP => _tenSP;
  set tenSP(String value) {
    if (value.isNotEmpty) _tenSP = value;
  }

  double get donGia => _donGia;
  set donGia(double value) {
    if (value > 0) _donGia = value;
  }

  double get giamGia => _giamGia;
  set giamGia(double value) {
    if (value >= 0) _giamGia = value;
  }

  // Tính thuế nhập khẩu (10% giá sản phẩm)
  double tinhThueNhapKhau() {
    return 0.10 * _donGia;
  }

  // Xuất thông tin
  void showInfo() {
    print("Mã sản phẩm: $_maSP, Tên: $_tenSP, Giá bán: $_donGia, Giảm giá: $_giamGia, Thuế: ${tinhThueNhapKhau()}");
  }
}