import 'package:flutter/material.dart';

class Bai01 extends StatelessWidget {
  const Bai01({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Thông tin sinh viên',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),

          backgroundColor: Colors.blue[800],

          leading: const Icon(
            Icons.home,
            color: Colors.black,
          ),
        ),

        body: Container(
          width: double.infinity,
          height: double.infinity,

          color: const Color(0xFFFFF8FF),

          child: Column(
            children: [

              const SizedBox(height: 35),

              // Ảnh sinh viên
              ClipOval(
                child: Image.asset(
                  'pictures/bai01.jpg',
                  width: 170,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 25),

              // Họ tên
              const Text(
                'Họ và tên: Nguyễn Văn A',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              // MSSV
              const Text(
                'MSSV: 2001221234',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              // Lớp
              const Text(
                'Lớp: 13DHTH02',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              // Khóa
              const Text(
                'Khóa: 13 Đại học',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              // Ngành
              const Text(
                'Ngành: Công nghệ thông tin',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              // Trường
              const Text(
                'Trường: Đại học Công Thương\n'
                'Thành phố Hồ Chí Minh',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 19,
                ),
              ),

              const SizedBox(height: 35),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text(
                  'Trở về',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}