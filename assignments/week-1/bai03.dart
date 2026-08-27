import 'dart:io';

bool laSoNguyenTo(int n) {
  if (n < 2) {
    return false;
  }

  for (int i = 2; i < n; i++) {
    if (n % i == 0) {
      return false;
    }
  }

  return true;
}

void main() {
  stdout.write("Nhập số lượng phần tử: ");
  int n = int.parse(stdin.readLineSync()!);

  List<int> ds = [];

  for (int i = 0; i < n; i++) {
    stdout.write("Nhập phần tử thứ ${i + 1}: ");
    int x = int.parse(stdin.readLineSync()!);

    ds.add(x);
  }

  // a. Xuất danh sách
  print("\na. Danh sách vừa nhập:");
  print(ds);

  // b. Tính tổng
  int tong = 0;

  for (int x in ds) {
    tong += x;
  }

  print("b. Tổng các phần tử = $tong");

  // c. Xuất số nguyên tố
  print("c. Các số nguyên tố:");

  bool coSoNguyenTo = false;

  for (int x in ds) {
    if (laSoNguyenTo(x)) {
      print(x);
      coSoNguyenTo = true;
    }
  }

  if (!coSoNguyenTo) {
    print("Không có số nguyên tố");
  }

  // d. Tìm giá trị
  stdout.write("d. Nhập giá trị cần tìm: ");
  int x = int.parse(stdin.readLineSync()!);

  int viTri = ds.indexOf(x);

  if (viTri == -1) {
    ds.insert(0, x);

    print("Không tìm thấy.");
    print("Đã thêm $x vào đầu danh sách.");
    print("Danh sách mới: $ds");
  } else {
    print("Tìm thấy $x tại vị trí ${viTri + 1}");
  }
}