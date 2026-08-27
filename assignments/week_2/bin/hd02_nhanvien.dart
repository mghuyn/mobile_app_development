import 'package:week_2/NhanVien.dart';

void mainBaiTap2() {
  print("==================================================");
  print("             BÀI TẬP HƯỚNG DẪN 2");
  print("==================================================");

  Nhanvien nv = Nhanvien.fullPara("NV001", "Nguyễn Trần Tuấn", 2.34, "Tổ chức", 23);
  CanBo cb = CanBo.fullPara('NV002', 'Trần Văn Bình', 2.34, "Tổ chức", 26, "Trưởng phòng", 2.0);
  Nhanvien nv3 = Nhanvien.fullPara("NV003", "Nguyễn Nam", 2.34, "Nhân sự", 27);

  // Tạo danh sách các cán bộ và nhân viên
  List<Nhanvien> lstNhanVien = [nv, cb, nv3];

  print("\n--- Danh sách nhân viên và cán bộ ---");
  for (Nhanvien x in lstNhanVien) {
    print(x);
  }

  // Danh sách nhân viên và cán bộ xếp loại A
  List<Nhanvien> lstLoaiA = lstNhanVien.where((a) => a.xepLoai() == "A").toList();
  print('\n--- Danh sách nhân viên và cán bộ xếp loại A ---');
  for (Nhanvien x in lstLoaiA) {
    print(x);
  }

  // Tính tổng thu nhập
  double tongLuong = lstNhanVien.fold(0, (sum, nv) => sum + nv.tinhLuong());
  print("\nTổng lương của nhân viên và cán bộ: $tongLuong");

  // Sắp xếp tăng dần theo lương
  lstNhanVien.sort((x, y) => x.tinhLuong().compareTo(y.tinhLuong()));
  print("\n--- Danh sách sau khi sắp xếp tăng dần theo lương ---");
  for (Nhanvien x in lstNhanVien) {
    print(x);
  }
}