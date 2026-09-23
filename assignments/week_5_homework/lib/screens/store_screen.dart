import 'package:flutter/material.dart';

import '../data/store_data.dart';
import '../widgets/product_card.dart';
import '../widgets/app_drawer.dart';
import 'cart_screen.dart';
import '../models/product.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  // Thêm sản phẩm vào giỏ
  void addToCart(Product product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn muốn thêm sản phẩm vào Giỏ hàng'),
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
                cart.add(product);
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã thêm sản phẩm vào giỏ hàng')),
              );
            },
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  // Mở giỏ hàng
  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        onStorePressed: () {
          Navigator.pop(context);
        },
        onCartPressed: () {
          Navigator.pop(context);
          openCart();
        },
      ),

      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          'Cửa hàng điện thoại',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: openCart,
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
              ),

              if (cart.isNotEmpty)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${cart.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: const Text(
              'Chọn sản phẩm bạn muốn sử dụng',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.68,
              ),
              itemCount: products.length,
              itemBuilder: (_, index) {
                return ProductCard(
                  product: products[index],
                  onAdd: () {
                    addToCart(products[index]);
                  },
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(14),
            child: const Text(
              'Sản phẩm được lựa chọn nhiều nhất',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
