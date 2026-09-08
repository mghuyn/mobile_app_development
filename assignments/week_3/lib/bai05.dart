import 'package:flutter/material.dart';

class Bai05 extends StatelessWidget {
  const Bai05({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Giới thiệu ngành học',
          ),
          backgroundColor: Colors.blue[800],
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Center(
                  child: Text(
                    'KHOA CÔNG NGHỆ THÔNG TIN',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  '1. NGÀNH CÔNG NGHỆ THÔNG TIN',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Ngành Công nghệ thông tin đào tạo sinh viên '
                  'có kiến thức về lập trình, cơ sở dữ liệu, '
                  'mạng máy tính, phát triển phần mềm và các '
                  'công nghệ hiện đại.',

                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  '2. NGÀNH AN TOÀN THÔNG TIN',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Ngành An toàn thông tin đào tạo kiến thức '
                  'về bảo mật hệ thống, mạng máy tính, '
                  'an ninh mạng, mã hóa và phòng chống các '
                  'mối đe dọa trong môi trường số.',

                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Trường: Đại học Công Thương Thành phố Hồ Chí Minh',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}