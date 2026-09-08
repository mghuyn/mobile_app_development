import 'package:flutter/material.dart';

class Bai04 extends StatelessWidget {
  const Bai04({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Thông tin nhóm'),
          backgroundColor: Colors.blue[800],
        ),

        body: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const Center(
                child: Text(
                  'THÔNG TIN NHÓM',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Mã nhóm: N01',
                style: TextStyle(fontSize: 19),
              ),

              const SizedBox(height: 15),

              const Text(
                'Tên nhóm: Nhóm Flutter',
                style: TextStyle(fontSize: 19),
              ),

              const SizedBox(height: 15),

              const Text(
                'Số lượng thành viên: 3',
                style: TextStyle(fontSize: 19),
              ),

              const SizedBox(height: 25),

              const Text(
                'Danh sách thành viên:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              member(
                '2001220001',
                'Nguyễn Văn A',
                'Nhóm trưởng',
              ),

              member(
                '2001220002',
                'Nguyễn Văn B',
                'Thành viên',
              ),

              member(
                '2001220003',
                'Nguyễn Văn C',
                'Thành viên',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget member(
    String mssv,
    String hoTen,
    String vaiTro,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        children: [

          const Icon(
            Icons.person,
            size: 35,
          ),

          const SizedBox(width: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'MSSV: $mssv',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),

              Text(
                'Họ tên: $hoTen',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),

              Text(
                'Vai trò: $vaiTro',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}