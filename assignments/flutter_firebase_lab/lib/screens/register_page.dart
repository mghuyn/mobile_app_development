import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmController.text;

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      showMessage('Vui lòng nhập đầy đủ thông tin');
      return;
    }

    if (password != confirm) {
      showMessage('Mật khẩu xác nhận không khớp');
      return;
    }

    if (password.length < 6) {
      showMessage('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showMessage('Đăng ký thất bại: ${e.message}');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFF0055);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: pink,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Icon(Icons.person_add, size: 65, color: pink),
              const SizedBox(height: 20),

              const Text(
                'ĐĂNG KÝ TÀI KHOẢN',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pink,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(loading ? 'Đang đăng ký...' : 'Đăng ký'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
