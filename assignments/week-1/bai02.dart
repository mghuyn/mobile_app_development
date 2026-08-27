import 'dart:io';

void main() {
  stdout.write("Nhập số nguyên dương > 10: ");
  int n = int.parse(stdin.readLineSync()!);

  // a. Đếm số chữ số
  int tam = n;
  int dem = 0;

  while (tam > 0) {
    dem++;
    tam = tam ~/ 10;
  }

  print("a. Số có $dem chữ số");

  // b. Tính tổng các chữ số
  tam = n;
  int tong = 0;

  while (tam > 0) {
    int chuSo = tam % 10;
    tong += chuSo;
    tam = tam ~/ 10;
  }

  print("b. Tổng các chữ số = $tong");

  // c. Kiểm tra có chữ số lẻ
  tam = n;
  bool coSoLe = false;

  while (tam > 0) {
    int chuSo = tam % 10;

    if (chuSo % 2 != 0) {
      coSoLe = true;
      break;
    }

    tam = tam ~/ 10;
  }

  if (coSoLe) {
    print("c. Có chứa chữ số lẻ");
  } else {
    print("c. Không chứa chữ số lẻ");
  }

  // d. Tìm chữ số lớn nhất
  tam = n;
  int max = 0;

  while (tam > 0) {
    int chuSo = tam % 10;

    if (chuSo > max) {
      max = chuSo;
    }

    tam = tam ~/ 10;
  }

  print("d. Chữ số lớn nhất = $max");

  // e. Kiểm tra có chữ số nguyên tố
  tam = n;
  bool coNguyenTo = false;

  while (tam > 0) {
    int chuSo = tam % 10;

    if (chuSo == 2 ||
        chuSo == 3 ||
        chuSo == 5 ||
        chuSo == 7) {
      coNguyenTo = true;
      break;
    }

    tam = tam ~/ 10;
  }

  if (coNguyenTo) {
    print("e. Có chứa chữ số nguyên tố");
  } else {
    print("e. Không chứa chữ số nguyên tố");
  }
}