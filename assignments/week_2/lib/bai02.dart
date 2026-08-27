import 'dart:io';


abstract class MonHoc {
  String maMH;
  String tenMH;
  int soTC;

  MonHoc(
    this.maMH,
    this.tenMH,
    this.soTC,
  );

  double tinhDTB();

  String xepLoai() {
    double diem = tinhDTB();

    if (diem >= 8.5) {
      return "A";
    } else if (diem >= 7.0) {
      return "B";
    } else if (diem >= 5.5) {
      return "C";
    } else if (diem >= 4.0) {
      return "D";
    } else {
      return "F";
    }
  }

  void xuat() {
    print(
      "$maMH | $tenMH | $soTC TC | "
      "DTB: ${tinhDTB().toStringAsFixed(2)} | "
      "Điểm chữ: ${xepLoai()}",
    );
  }
}


class MonLyThuyet extends MonHoc {
  double diemTieuLuan;
  double diemCuoiKy;

  MonLyThuyet(
    String maMH,
    String tenMH,
    int soTC,
    this.diemTieuLuan,
    this.diemCuoiKy,
  ) : super(maMH, tenMH, soTC);

  @override
  double tinhDTB() {
    return diemTieuLuan * 0.3 +
        diemCuoiKy * 0.7;
  }
}

class MonThucHanh extends MonHoc {
  double diem1;
  double diem2;
  double diem3;

  MonThucHanh(
    String maMH,
    String tenMH,
    int soTC,
    this.diem1,
    this.diem2,
    this.diem3,
  ) : super(maMH, tenMH, soTC);

  @override
  double tinhDTB() {
    return (diem1 + diem2 + diem3) / 3;
  }
}

class MonDoAn extends MonHoc {
  double diemGVHD;
  double diemGVPB;

  MonDoAn(
    String maMH,
    String tenMH,
    int soTC,
    this.diemGVHD,
    this.diemGVPB,
  ) : super(maMH, tenMH, soTC);

  @override
  double tinhDTB() {
    return (diemGVHD + diemGVPB) / 2;
  }
}


double nhapDiem(String thongBao) {
  while (true) {
    stdout.write(thongBao);

    try {
      double diem = double.parse(stdin.readLineSync()!);

      if (diem >= 0 && diem <= 10) {
        return diem;
      }

      print("Điểm phải từ 0 đến 10!");
    } catch (e) {
      print("Vui lòng nhập số!");
    }
  }
}


MonHoc nhapMonHoc() {
  stdout.write("Nhập mã môn học: ");
  String ma = stdin.readLineSync()!;

  stdout.write("Nhập tên môn học: ");
  String ten = stdin.readLineSync()!;

  stdout.write("Nhập số tín chỉ: ");
  int tc = int.parse(stdin.readLineSync()!);

  print("\n1. Lý thuyết");
  print("2. Thực hành");
  print("3. Đồ án");

  stdout.write("Chọn loại môn: ");
  int loai = int.parse(stdin.readLineSync()!);

  if (loai == 1) {
    double tieuLuan =
        nhapDiem("Điểm tiểu luận: ");

    double cuoiKy =
        nhapDiem("Điểm cuối kỳ: ");

    return MonLyThuyet(
      ma,
      ten,
      tc,
      tieuLuan,
      cuoiKy,
    );
  }

  if (loai == 2) {
    double diem1 =
        nhapDiem("Điểm kiểm tra 1: ");

    double diem2 =
        nhapDiem("Điểm kiểm tra 2: ");

    double diem3 =
        nhapDiem("Điểm kiểm tra 3: ");

    return MonThucHanh(
      ma,
      ten,
      tc,
      diem1,
      diem2,
      diem3,
    );
  }

  double gvhd =
      nhapDiem("Điểm GV hướng dẫn: ");

  double gvpb =
      nhapDiem("Điểm GV phản biện: ");

  return MonDoAn(
    ma,
    ten,
    tc,
    gvhd,
    gvpb,
  );
}

void main() {
  List<MonHoc> danhSach = [];

  int n;

  stdout.write("Nhập số môn học: ");
  n = int.parse(stdin.readLineSync()!);

  // Nhập danh sách
  for (int i = 0; i < n; i++) {
    print("\n===== NHẬP MÔN ${i + 1} =====");

    danhSach.add(nhapMonHoc());
  }

  // Xuất danh sách
  print("\n===== DANH SÁCH MÔN HỌC =====");

  for (MonHoc mon in danhSach) {
    mon.xuat();
  }

  // Kiểm tra đã tăng dần theo tên chưa
  bool tangDan = true;

  for (int i = 0; i < danhSach.length - 1; i++) {
    if (danhSach[i]
            .tenMH
            .compareTo(danhSach[i + 1].tenMH) >
        0) {
      tangDan = false;
      break;
    }
  }

  print("\n===== KIỂM TRA THỨ TỰ TÊN =====");

  if (tangDan) {
    print("Danh sách đã được sắp xếp tăng dần theo tên.");
  } else {
    print("Danh sách chưa được sắp xếp tăng dần theo tên.");
  }

  // Sắp xếp tăng dần theo số tín chỉ
  danhSach.sort(
    (a, b) => a.soTC.compareTo(b.soTC),
  );

  print("\n===== SẮP XẾP THEO SỐ TÍN CHỈ =====");

  for (MonHoc mon in danhSach) {
    mon.xuat();
  }

  // Tìm số tín chỉ cao nhất
  int maxTC = 0;

  for (MonHoc mon in danhSach) {
    if (mon.soTC > maxTC) {
      maxTC = mon.soTC;
    }
  }

  print("\n===== MÔN CÓ SỐ TÍN CHỈ CAO NHẤT =====");

  for (MonHoc mon in danhSach) {
    if (mon.soTC == maxTC) {
      mon.xuat();
    }
  }

  // Tìm môn theo tên
  stdout.write("\nNhập tên môn cần tìm: ");
  String tenCanTim = stdin.readLineSync()!;

  MonHoc? monTimThay;

  for (MonHoc mon in danhSach) {
    if (mon.tenMH.toLowerCase() ==
        tenCanTim.toLowerCase()) {
      monTimThay = mon;
      break;
    }
  }

  if (monTimThay != null) {
    print("\nTìm thấy môn học:");
    monTimThay.xuat();
  } else {
    print("Không tìm thấy môn học.");
  }

  // Tính số tín chỉ trung bình
  if (danhSach.isNotEmpty) {
    double tongTC = 0;

    for (MonHoc mon in danhSach) {
      tongTC += mon.soTC;
    }

    double trungBinh =
        tongTC / danhSach.length;

    print(
      "\nSố tín chỉ trung bình: "
      "${trungBinh.toStringAsFixed(2)}",
    );
  }
}