import 'package:flutter/material.dart';

import 'store_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: const Icon(
                  Icons.phone_android,
                  size: 70,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Cửa hàng điện thoại',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                '140 Lê Trọng Tấn, Tân Phú, TP. Hồ Chí Minh',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),

              const SizedBox(height: 25),

              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const StoreScreen()),
                  );
                },
                child: Container(
                  width: 65,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
