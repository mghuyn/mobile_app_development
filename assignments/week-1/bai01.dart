import 'dart:io';
void main()
{
  print("Nhap vao so que kem: ");
  int n=int.parse(stdin.readLineSync()!);

  print("Nhap gia 1 que kem: ");
  double gia=double.parse(stdin.readLineSync()!);

  double tien=n*gia;
  if(n>10) tien*=0.9;
  else if(n>=55&&n<=10) tien*=0.95;

  print("So tien can thanh toan: $tien");
}