import 'dart:io';

abstract class PhongThue
{
  String maP;
  int slng;
  double sodien;
  double sonuoc;

  //PhongTro(string map, int slng,double sodien,double sonuoc)
  //{
   //   this.maP=map;
   //   this.slng=slng;
   //   this.sodien=sodien;
   //   this.sonuoc=sonuoc;
  //}
 PhongThue(this.maP,this.slng,this.sodien,this.sonuoc);
  double TinhTienPhong();
  void XuatTT()
  {
    print("""Ma phong: $maP
          So luong nguoi o: $slng
          So dien: $sodien
          So nuoc: $sonuoc
          Tong tien phong: ${TinhTienPhong()}""");
  }
}
class PhongLoaiA extends PhongThue
{
    int so_ngthan;
    PhongLoaiA(String maP,int slng,double sodien,double sonuoc,this.so_ngthan,) : super(maP, slng, sodien, sonuoc);
    @override
    double TinhTienPhong()
    {
      return 1400+2*sodien+8*sonuoc+50*so_ngthan;
    }

    @override void XuatTT()
    {
      print("""Ma phong: $maP
          So luong nguoi o: $slng
          So dien: $sodien
          So nuoc: $sonuoc
          So nguoi than: $so_ngthan
          Tong tien phong: ${TinhTienPhong()}""");
    }
    
}
class PhongLoaiB extends PhongThue{
  double giatui;
  int somay;
  PhongLoaiB(String maP,int slng, double sodien,double sonuoc,this.giatui, this.somay,) : super(maP, slng, sodien, sonuoc);
  @override double TinhTienPhong()
  {
    return 2000+2*sodien+8*sonuoc+5*giatui+100*somay;
  }

  @override void XuatTT()
    {
      print("""Ma phong: $maP
          So luong nguoi o: $slng
          So dien: $sodien
          So nuoc: $sonuoc
          So may: $somay
          Khoi luong giat ui: $giatui
          Tong tien phong: ${TinhTienPhong()}""");
    }
}

//doc file noi dung doi tuong
Future<List<PhongThue>> docFile(String tenFile) async {
  List<PhongThue> danhSach = [];

  try {
    File file = File(tenFile);

    List<String> lines = await file.readAsLines();

    for (String line in lines) {
      List<String> parts = line.split("#");

      if (parts[0].startsWith("A") && parts.length == 5) {
        String maP = parts[0];
        int slng = int.parse(parts[1]);
        double sodien = double.parse(parts[2]);
        double sonuoc = double.parse(parts[3]);
        int so_ngthan = int.parse(parts[4]);

        danhSach.add( PhongLoaiA(  maP, slng, sodien,  sonuoc, so_ngthan,), );
      } else if (parts[0].startsWith("B") && parts.length == 6) {
        String maP = parts[0];
        int slng = int.parse(parts[1]);
        double sodien = double.parse(parts[2]);
        double sonuoc = double.parse(parts[3]);
        double giatui = double.parse(parts[4]);
        int somay = int.parse(parts[5]);

        danhSach.add(PhongLoaiB(maP,slng, sodien, sonuoc, giatui,  somay, ), );
      }
    }
  } catch (e) {
    print("Lỗi khi đọc file: $e");
  }

  return danhSach;
}

// =========================
// MAIN
// =========================
void main() async {
  List<PhongThue> danhSach =
      await docFile("lib/phongthue.txt");

  // 1. In danh sách phòng
  print(" danh sach phong thue ");

  for (PhongThue phong in danhSach) {
    phong.XuatTT();
  }

  // 2. Phòng có số người > 2
  print("\n phong co ng  > 2 ");

  for (PhongThue phong in danhSach) {
    if (phong.slng > 2) {
      phong.XuatTT();
    }
  }

  // 3. Tổng tiền phòng
  double tongTien = 0;

  for (PhongThue phong in danhSach) {
    tongTien += phong.TinhTienPhong();
  }

  print("\n===== TỔNG TIỀN PHÒNG =====");
  print("Tổng tiền: $tongTien");

  // 4. Sắp xếp giảm dần theo số điện
  danhSach.sort((a, b) => b.sodien.compareTo(a.sodien), );

  print("\n===== SẮP XẾP GIẢM DẦN THEO SỐ ĐIỆN =====");

  for (PhongThue phong in danhSach) {
    phong.XuatTT();
  }

  // 5. In phòng loại A
  print("\n===== DANH SÁCH PHÒNG LOẠI A =====");

  for (PhongThue phong in danhSach) {
    if (phong is PhongLoaiA) {
      phong.XuatTT();
    }
  }
}

