class Nhanvien {
  String _maNV = '';
  String _tenNV = '';
  double _heSoLuong = 0.0;
  String _phongBan = '';
  double _soNgayLV = 0.0;
  static double LCB = 2340;

  // Getters & Setters
  String get maNV => _maNV;
  String get tenNV => _tenNV;
  double get heSoLuong => _heSoLuong;
  String get phongBan => _phongBan;
  double get soNgayLV => _soNgayLV;

  // Constructor
  Nhanvien() {
    _maNV = "NV000";
    _tenNV = "Nguyễn Văn A";
    _heSoLuong = 2.34;
    _phongBan = "Tổ chức";
    _soNgayLV = 22;
  }

  Nhanvien.fullPara(String manv, String tennv, double hsl, String pb, double songaylv) {
    _maNV = manv;
    _tenNV = tennv;
    _heSoLuong = hsl;
    _phongBan = pb;
    _soNgayLV = songaylv;
  }

  // Phương thức xếp loại
  String xepLoai() {
    if (_soNgayLV > 25) {
      return 'A';
    } else if (_soNgayLV > 22) {
      return 'B';
    } else {
      return 'C';
    }
  }

  // Phương thức tính lương
  double tinhLuong() {
    String xLoai = xepLoai();
    double hsThiDua = 0.5;
    if (xLoai == 'A') {
      hsThiDua = 1.0;
    } else if (xLoai == 'B') {
      hsThiDua = 0.75;
    }
    return LCB * _heSoLuong * hsThiDua;
  }

  @override
  String toString() {
    return "$_maNV\t$_tenNV\t$_heSoLuong\t$_soNgayLV\t${xepLoai()}\t${tinhLuong()}";
  }
}

// Lớp Cán bộ quản lý
class CanBo extends Nhanvien {
  String _chucVu = '';
  double _hsChucVu = 0;

  CanBo() : super() {
    _chucVu = "Unknown";
    _hsChucVu = 0;
  }

  CanBo.fullPara(String manv, String tennv, double hsl, String pb, double songaylv, String chucvu, double hscv)
      : super.fullPara(manv, tennv, hsl, pb, songaylv) {
    _chucVu = chucvu;
    _hsChucVu = hscv;
  }

  @override
  double tinhLuong() {
    return super.tinhLuong() + _hsChucVu * 1100;
  }

  @override
  String toString() {
    return "${super.toString()}\t$_chucVu\t$_hsChucVu";
  }
}