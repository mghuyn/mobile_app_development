import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Chưa đăng nhập Google thì bỏ qua.
    }

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    const pink = Color(0xFFFF0055);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: pink,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: pink),
            const SizedBox(height: 20),

            const Text(
              'ĐĂNG NHẬP THÀNH CÔNG!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            Text(
              'Email: ${user?.email ?? "Không có"}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            Text('Tên: ${user?.displayName ?? "Chưa cập nhật"}'),
            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Đăng xuất'),
              style: ElevatedButton.styleFrom(
                backgroundColor: pink,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
