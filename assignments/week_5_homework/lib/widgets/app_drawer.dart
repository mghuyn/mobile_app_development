import 'package:flutter/material.dart';

import '../data/store_data.dart';
import '../screens/welcome_screen.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onStorePressed;
  final VoidCallback onCartPressed;

  const AppDrawer({
    super.key,
    required this.onStorePressed,
    required this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Thông tin người dùng
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            color: Colors.white,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  child: Icon(Icons.phone_android),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Võ Văn Vĩnh',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'vinhth@huit.edu.vn',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu
          Expanded(
            child: Container(
              color: Colors.lightBlue,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Cửa hàng
                  ListTile(
                    leading: const Icon(Icons.store),
                    title: const Text('Cửa hàng'),
                    onTap: onStorePressed,
                  ),

                  // Giỏ hàng
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: Row(
                      children: [
                        const Text('Giỏ hàng'),

                        if (cart.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${cart.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: onCartPressed,
                  ),

                  // Thoát
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Thoát'),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WelcomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
