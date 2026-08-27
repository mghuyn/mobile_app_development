import 'dart:io';

void main() {
  // a. Nhập và xuất chuỗi
  stdout.write("Nhập chuỗi: ");
  String s = stdin.readLineSync()!;

  print("a. Chuỗi vừa nhập: $s");

  // b. Đếm nguyên âm
  int demNguyenAm = 0;

  String chuoiThuong = s.toLowerCase();

  for (int i = 0; i < chuoiThuong.length; i++) {
    if ("aeiou".contains(chuoiThuong[i])) {
      demNguyenAm++;
    }
  }

  print("b. Số ký tự nguyên âm = $demNguyenAm");

  // c. Đếm số từ
  if (s.trim().isEmpty) {
    print("c. Chuỗi có 0 từ");
  } else {
    List<String> tu = s.trim().split(RegExp(r'\s+'));

    print("c. Chuỗi có ${tu.length} từ");
  }

  // d. Kiểm tra chuỗi đối xứng
  bool doiXung = true;

  for (int i = 0; i < s.length ~/ 2; i++) {
    if (s[i] != s[s.length - 1 - i]) {
      doiXung = false;
      break;
    }
  }

  if (doiXung) {
    print("d. Chuỗi đối xứng.");
  } else {
    print("d. Chuỗi không đối xứng.");
  }

  // e. Đảo ngược từ
  if (s.trim().isEmpty) {
    print("e. Chuỗi rỗng.");
  } else {
    List<String> tu = s.trim().split(RegExp(r'\s+'));

    List<String> ketQua = tu.reversed.toList();

    print("e. Chuỗi sau khi đảo ngược từ:");
    print(ketQua.join(" "));
  }
}