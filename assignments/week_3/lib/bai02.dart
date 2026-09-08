import 'package:flutter/material.dart';

class Bai02 extends StatelessWidget {
  const Bai02({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Thông tin đề tài đồ án'),
          backgroundColor: Colors.blue[800],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'THÔNG TIN ĐỀ TÀI ĐỒ ÁN',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Mã đề tài: DA001',
                  style: TextStyle(fontSize: 19),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Tên đề tài: Xây dựng ứng dụng quản lý quán cà phê',
                  style: TextStyle(fontSize: 19),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Số lượng sinh viên tối đa: 3',
                  style: TextStyle(fontSize: 19),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Chuyên ngành: Công nghệ phần mềm',
                  style: TextStyle(fontSize: 19),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Giảng viên hướng dẫn: Nguyễn Văn B',
                  style: TextStyle(fontSize: 19),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Yêu cầu đề tài:',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  '• Phân tích yêu cầu hệ thống\n'
                  '• Thiết kế cơ sở dữ liệu\n'
                  '• Xây dựng giao diện\n'
                  '• Xây dựng các chức năng quản lý\n'
                  '• Kiểm thử và hoàn thiện ứng dụng',
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 35),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Trở về'),
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