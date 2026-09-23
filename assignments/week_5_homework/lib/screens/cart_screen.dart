import 'package:flutter/material.dart';

import '../data/store_data.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Xóa sản phẩm
  void removeProduct(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn muốn loại bỏ sản phẩm này khỏi giỏ hàng'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                cart.removeAt(index);
              });

              Navigator.pop(context);
            },
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  // Thanh toán
  void payment() {
    // Giỏ hàng rỗng
    if (cart.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Thanh toán'),
          content: const Text('Bạn chưa có sản phẩm nào trong giỏ hàng!!!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Đóng'),
            ),
          ],
        ),
      );

      return;
    }

    // Có sản phẩm
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thanh toán'),
        content: const Text('Bạn đã thanh toán xong giỏ hàng'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                cart.clear();
              });

              Navigator.pop(context);
            },
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  // Tính tổng tiền
  double get total {
    return cart.fold(0, (sum, product) => sum + product.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        title: const Text('Giỏ hàng của bạn', style: TextStyle(fontSize: 18)),
      ),

      body: Column(
        children: [
          // Danh sách sản phẩm
          Expanded(
            child: cart.isEmpty
                ? const Center(
                    child: Text(
                      'Bạn chưa có sản phẩm nào trong giỏ hàng!!!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (_, index) {
                      final product = cart[index];

                      return Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 1),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            // Hình sản phẩm
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.asset(
                                product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) {
                                  return const Icon(
                                    Icons.smartphone,
                                    size: 45,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 15),

                            // Tên + giá
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    product.price.toStringAsFixed(1),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),

                            // Nút xóa
                            IconButton(
                              onPressed: () {
                                removeProduct(index);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Tổng tiền
          if (cart.isNotEmpty)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng tiền:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    total.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          // Thanh toán
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 20, top: 8),
            child: Center(
              child: ElevatedButton(
                onPressed: payment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                ),
                child: const Text('Thanh toán'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
