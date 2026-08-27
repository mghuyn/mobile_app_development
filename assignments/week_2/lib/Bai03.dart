import 'dart:io';

// ============================================================================
// LỚP HÓA ĐƠN TRỪU TƯỢNG
// ============================================================================
abstract class HoaDon {
  String maKH;
  String tenKH;
  int soLuong;
  double giaBan;

  HoaDon(this.maKH, this.tenKH, this.soLuong, this.giaBan);

  double tinhChietKhau();
  double tinhTroGia();
  String loaiKhachHang();

  double tinhVAT() {
    return soLuong * giaBan * 0.10;
  }

  double tinhThanhTien() {
    return (soLuong * giaBan) - tinhChietKhau() + tinhVAT() - tinhTroGia();
  }

  // In 1 dòng dữ liệu dạng bảng
  void xuatDong() {
    String strMa = maKH.padRight(8);
    String strTen = tenKH.padRight(18);
    String strLoai = loaiKhachHang().padRight(14);
    String strSL = soLuong.toString().padLeft(4);
    String strGia = giaBan.toStringAsFixed(0).padLeft(11);
    String strCK = tinhChietKhau().toStringAsFixed(0).padLeft(10);
    String strTG = tinhTroGia().toStringAsFixed(0).padLeft(10);
    String strTT = tinhThanhTien().toStringAsFixed(0).padLeft(13);

    print("│ $strMa│ $strTen│ $strLoai│ $strSL │ $strGia │ $strCK │ $strTG │ $strTT │");
  }
}

// ============================================================================
// KHÁCH HÀNG CÁ NHÂN
// ============================================================================
class KhachHangCaNhan extends HoaDon {
  double khoangCach;

  KhachHangCaNhan(
    String maKH,
    String tenKH,
    int soLuong,
    double giaBan,
    this.khoangCach,
  ) : super(maKH, tenKH, soLuong, giaBan);

  @override
  String loaiKhachHang() => "Ca nhan";

  @override
  double tinhChietKhau() {
    double chietKhau = 0;
    if (soLuong >= 3) {
      chietKhau += soLuong * giaBan * 0.05;
    }
    if (khoangCach < 10) {
      chietKhau += soLuong * 50000;
    }
    return chietKhau;
  }

  @override
  double tinhTroGia() {
    double troGia = soLuong * giaBan * 0.02;
    if (soLuong > 2) {
      troGia += 100000;
    }
    return troGia;
  }
}

// ============================================================================
// ĐẠI LÝ CẤP 1
// ============================================================================
class DaiLyCap1 extends HoaDon {
  int soNamHopTac;

  DaiLyCap1(
    String maKH,
    String tenKH,
    int soLuong,
    double giaBan,
    this.soNamHopTac,
  ) : super(maKH, tenKH, soLuong, giaBan);

  @override
  String loaiKhachHang() => "Dai ly cap 1";

  @override
  double tinhChietKhau() {
    double phanTram = 0.30;
    if (soNamHopTac > 5) {
      phanTram += (soNamHopTac - 5) * 0.01;
      if (phanTram > 0.35) phanTram = 0.35;
    }
    return soLuong * giaBan * phanTram;
  }

  @override
  double tinhTroGia() => 0;
}

// ============================================================================
// KHÁCH HÀNG CÔNG TY
// ============================================================================
class KhachHangCongTy extends HoaDon {
  int soNhanVien;

  KhachHangCongTy(
    String maKH,
    String tenKH,
    int soLuong,
    double giaBan,
    this.soNhanVien,
  ) : super(maKH, tenKH, soLuong, giaBan);

  @override
  String loaiKhachHang() => "Cong ty";

  @override
  double tinhChietKhau() {
    double phanTram = 0;
    if (soNhanVien > 5000) {
      phanTram = 0.07;
    } else if (soNhanVien > 1000) {
      phanTram = 0.05;
    }
    return soLuong * giaBan * phanTram;
  }

  @override
  double tinhTroGia() => soLuong * 120000;
}

// ============================================================================
// KIỂM TRA MÃ KHÁCH HÀNG
// ============================================================================
bool kiemTraMaKH(String ma) {
  if (ma.length != 6 || !ma.startsWith("KH")) return false;
  return int.tryParse(ma.substring(2)) != null;
}

// ============================================================================
// NHẬP HÓA ĐƠN
// ============================================================================
HoaDon nhapHoaDon() {
  String maKH;
  while (true) {
    stdout.write("Ma khach hang (Vi du: KH0001): ");
    maKH = stdin.readLineSync()!.trim();
    if (kiemTraMaKH(maKH)) break;
    print("Moi nhap lai! Ma phai co dinh dang KHxxxx (4 chu so).");
  }

  String tenKH;
  while (true) {
    stdout.write("Ten khach hang: ");
    tenKH = stdin.readLineSync()!.trim();
    if (tenKH.isNotEmpty) break;
    print("Ten khach hang khong duoc de me!");
  }

  int soLuong;
  while (true) {
    stdout.write("So luong mua: ");
    try {
      soLuong = int.parse(stdin.readLineSync()!);
      if (soLuong > 0) break;
    } catch (_) {}
    print("So luong phai la so nguyen > 0!");
  }

  double giaBan;
  while (true) {
    stdout.write("Gia ban: ");
    try {
      giaBan = double.parse(stdin.readLineSync()!);
      if (giaBan > 0) break;
    } catch (_) {}
    print("Gia ban phai > 0!");
  }

  print("------------------------------------------");
  print("Chon loai khach hang:");
  print("1. Ca nhan");
  print("2. Dai ly cap 1");
  print("3. Cong ty");
  stdout.write("Chon (1-3): ");
  int loai = int.tryParse(stdin.readLineSync()!) ?? 1;

  if (loai == 1) {
    stdout.write("Khoang cach giao hang (km): ");
    double km = double.tryParse(stdin.readLineSync()!) ?? 0;
    return KhachHangCaNhan(maKH, tenKH, soLuong, giaBan, km);
  } else if (loai == 2) {
    stdout.write("So nam hop tac: ");
    int nam = int.tryParse(stdin.readLineSync()!) ?? 0;
    return DaiLyCap1(maKH, tenKH, soLuong, giaBan, nam);
  } else {
    stdout.write("So luong nhan vien: ");
    int nv = int.tryParse(stdin.readLineSync()!) ?? 0;
    return KhachHangCongTy(maKH, tenKH, soLuong, giaBan, nv);
  }
}

// ============================================================================
// QUẢN LÝ HÓA ĐƠN
// ============================================================================
class QuanLyHoaDon {
  List<HoaDon> danhSach = [];

  void themHoaDon(HoaDon hd) => danhSach.add(hd);

  void inTieuDeBang() {
    print("┌" + "─" * 104 + "┐");
    print("│ Ma KH   │ Ten KH            │ Loai KH       │  SL  │     Gia ban │   Chiet khau │      Tro gia │    Thanh tien │");
    print("├" + "─" * 104 + "┤");
  }

  void inChanBang() {
    print("└" + "─" * 104 + "┘");
  }

  void xuatDanhSach() {
    if (danhSach.isEmpty) {
      print("Danh sach hoa don rong!");
      return;
    }
    inTieuDeBang();
    for (HoaDon hd in danhSach) {
      hd.xuatDong();
    }
    inChanBang();
  }

  double tongThanhTien() => danhSach.fold(0, (sum, hd) => sum + hd.tinhThanhTien());

  double tongTroGia() => danhSach.fold(0, (sum, hd) => sum + hd.tinhTroGia());

  HoaDon? muaNhieuNhat() {
    if (danhSach.isEmpty) return null;
    HoaDon max = danhSach[0];
    for (HoaDon hd in danhSach) {
      if (hd.soLuong > max.soLuong) max = hd;
    }
    return max;
  }

  double tongChietKhauCongTy() {
    double tong = 0;
    for (HoaDon hd in danhSach) {
      if (hd is KhachHangCongTy) tong += hd.tinhChietKhau();
    }
    return tong;
  }

  void sapXep() {
    danhSach.sort((a, b) {
      int kq = a.soLuong.compareTo(b.soLuong);
      if (kq != 0) return kq;
      return b.tinhThanhTien().compareTo(a.tinhThanhTien());
    });
  }

  void timTheoMa(String ma) {
    var result = danhSach.where((hd) => hd.maKH == ma).toList();
    if (result.isEmpty) {
      print("Khach hang la");
    } else {
      inTieuDeBang();
      for (HoaDon hd in result) {
        hd.xuatDong();
      }
      inChanBang();
    }
  }
}

// ============================================================================
// MAIN
// ============================================================================
void main() {
  QuanLyHoaDon ql = QuanLyHoaDon();

  print("==========================================================================================================");
  print("                              CONG TY MAY LANH ABC - QUAN LY HOA DON                                     ");
  print("==========================================================================================================");

  stdout.write("\nNhap so luong hoa don: ");
  int n = int.tryParse(stdin.readLineSync()!) ?? 0;

  for (int i = 0; i < n; i++) {
    print("\n------------------------------------------");
    print("HOA DON THU ${i + 1}");
    print("------------------------------------------");
    HoaDon hd = nhapHoaDon();
    ql.themHoaDon(hd);
  }

  // 1. Xuất danh sách
  print("\n=================================== 1. DANH SACH HOA DON ===================================");
  ql.xuatDanhSach();

  // 2. Báo cáo tổng quan
  print("\n=================================== 2. BAO CAO TAI CHINH ===================================");
  print("Tong thanh tien tat ca hoa don : ${ql.tongThanhTien().toStringAsFixed(0)} VND");
  print("Tong so tien da tro gia        : ${ql.tongTroGia().toStringAsFixed(0)} VND");
  print("Tong chiet khau cho KH Cong ty : ${ql.tongChietKhauCongTy().toStringAsFixed(0)} VND");

  // 3. Khách mua nhiều nhất
  print("\n=================================== 3. KHACH MUA NHIEU NHAT ================================");
  HoaDon? max = ql.muaNhieuNhat();
  if (max != null) {
    ql.inTieuDeBang();
    max.xuatDong();
    ql.inChanBang();
  }

  // 4. Sắp xếp
  ql.sapXep();
  print("\n=================================== 4. SAU KHI SAP XEP =====================================");
  ql.xuatDanhSach();

  // 5. Tìm kiếm
  print("\n=================================== 5. TIM KIEM HOA DON ====================================");
  stdout.write("Nhap ma KH can tim: ");
  String maTim = stdin.readLineSync()!.trim();
  ql.timTheoMa(maTim);
}