import 'package:flutter/material.dart';

class Bai03 extends StatelessWidget {
  const Bai03({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Thông tin sản phẩm'),
          backgroundColor: Colors.blue[800],
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Center(
                  child: Text(
                    'THÔNG TIN SẢN PHẨM',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // 3 hình ảnh
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [

                    Image.asset(
                      'pictures/sp1.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),

                    Image.asset(
                      'pictures/sp2.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),

                    Image.asset(
                      'pictures/sp3.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  'Mã sản phẩm: SP001',
                  style: TextStyle(fontSize: 19),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Tên sản phẩm: Laptop Dell Inspiron',
                  style: TextStyle(fontSize: 19),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Nhà sản xuất: Dell',
                  style: TextStyle(fontSize: 19),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Giá bán: 15.000.000 VNĐ',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Mô tả sản phẩm:',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Laptop Dell Inspiron phù hợp cho học tập, '
                  'lập trình và làm việc văn phòng. '
                  'Thiết kế hiện đại, hiệu năng ổn định.',
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
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