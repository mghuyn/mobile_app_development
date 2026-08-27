import 'dart:io';
import 'dart:math';

void main() {
  Random rd = Random();

  stdout.write("Nhập số lượng phần tử: ");
  int n = int.parse(stdin.readLineSync()!);

  List<int> ds = [];

  // Tạo danh sách ngẫu nhiên từ 5 đến 100
  for (int i = 0; i < n; i++) {
    ds.add(rd.nextInt(96) + 5);
  }

  // a. Xuất danh sách
  print("\na. Danh sách:");
  print(ds);

  // b. Tính tổng
  int tong = 0;

  for (int x in ds) {
    tong += x;
  }

  print("b. Tổng = $tong");

  // c. Trung bình cộng số lẻ
  int tongLe = 0;
  int demLe = 0;

  for (int x in ds) {
    if (x % 2 != 0) {
      tongLe += x;
      demLe++;
    }
  }

  if (demLe == 0) {
    print("c. Danh sách không có số lẻ.");
  } else {
    double trungBinh = tongLe / demLe;
    print("c. Trung bình cộng các số lẻ = $trungBinh");
  }

  // d. Kiểm tra đối xứng
  bool doiXung = true;

  for (int i = 0; i < ds.length ~/ 2; i++) {
    if (ds[i] != ds[ds.length - 1 - i]) {
      doiXung = false;
      break;
    }
  }

  if (doiXung) {
    print("d. Danh sách đối xứng.");
  } else {
    print("d. Danh sách không đối xứng.");
  }

  // e. Kiểm tra tăng dần
  bool tangDan = true;

  for (int i = 0; i < ds.length - 1; i++) {
    if (ds[i] > ds[i + 1]) {
      tangDan = false;
      break;
    }
  }

  if (tangDan) {
    print("e. Danh sách được sắp xếp tăng dần.");
  } else {
    print("e. Danh sách không được sắp xếp tăng dần.");
  }

  // f. Tìm phần tử lớn nhất
  int max = ds[0];

  for (int i = 1; i < ds.length; i++) {
    if (ds[i] > max) {
      max = ds[i];
    }
  }

  print("f. Phần tử lớn nhất = $max");

  // g. Tìm số chẵn lớn nhất
  int? maxChan;

  for (int x in ds) {
    if (x % 2 == 0) {
      if (maxChan == null || x > maxChan!) {
        maxChan = x;
      }
    }
  }

  if (maxChan == null) {
    print("g. Danh sách không có số chẵn.");
  } else {
    print("g. Số chẵn lớn nhất = $maxChan");
  }

  // h. Tìm và xóa
  stdout.write("h. Nhập giá trị cần tìm: ");
  int x = int.parse(stdin.readLineSync()!);

  if (!ds.contains(x)) {
    print("Không tìm thấy.");
  } else {
    ds.removeWhere((element) => element == x);

    print("Đã xóa các phần tử có giá trị $x.");
    print("Danh sách sau khi xóa: $ds");
  }
}