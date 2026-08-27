import 'package:week_2/SanPham.dart';

void mainBaiTap1() {
  print("==================================================");
  print("             BÀI TẬP HƯỚNG DẪN 1");
  print("==================================================");

  // Khởi tạo sản phẩm mặc định
  SanPham sp = SanPham();
  sp.showInfo();

  // Khởi tạo sản phẩm có tham số
  SanPham sp1 = SanPham.fullPara('SP001', 'Bánh gạo Nhật', 25000, 0);
  sp1.showInfo();

  // Danh sách sản phẩm
  List<SanPham> lstSanPham = [];
  SanPham sp2 = SanPham.fullPara('SP002', 'Trà ô long', 75000, 0);
  SanPham sp3 = SanPham.fullPara('SP003', 'Mứt xoài sấy', 45000, 0);

  lstSanPham.add(sp1);
  lstSanPham.add(sp2);
  lstSanPham.add(sp3);

  print("\n--- Danh sách sản phẩm ---");
  for (SanPham a in lstSanPham) {
    a.showInfo();
  }
}