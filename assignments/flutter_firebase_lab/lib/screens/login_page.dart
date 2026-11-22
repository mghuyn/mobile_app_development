import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;

  static const blue = Color(0xFF2196F3);
  bool loading = false;

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      showMessage('Vui lòng nhập email và mật khẩu');
      return;
    }

    setState(() => loading = true);

    try {
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;
      goHome();
    } on FirebaseAuthException catch (e) {
      showMessage('Đăng nhập thất bại: ${e.message}');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> loginGoogle() async {
    setState(() => loading = true);

    try {
      if (kIsWeb) {
        await auth.signInWithPopup(GoogleAuthProvider());
      } else {
        final google = GoogleSignIn.instance;
        await google.initialize();

        final googleUser = await google.authenticate();
        final googleAuth = googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        await auth.signInWithCredential(credential);
      }

      if (!mounted) return;
      goHome();
    } catch (e) {
      showMessage('Lỗi đăng nhập Google: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget socialButton({
    required Widget child,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 55,
      height: 43,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(color: Color(0xFFDDDDDD)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Appwrite App', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 43,
                child: ElevatedButton.icon(
                  onPressed: loading ? null : login,
                  icon: const Icon(Icons.login, size: 18),
                  label: Text(loading ? 'Đang xử lý...' : 'Sign in'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: const Text(
                  'Create Account',
                  style: TextStyle(color: blue, fontSize: 13),
                ),
              ),

              TextButton(
                onPressed: () {
                  showMessage('Chức năng khách chưa được yêu cầu trong bài');
                },
                child: const Text(
                  'Read Messages as Guest',
                  style: TextStyle(color: blue, fontSize: 13),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Google
                  socialButton(
                    onPressed: loading ? () {} : loginGoogle,
                    child: const Text(
                      'G',
                      style: TextStyle(
                        color: Color(0xFF4285F4),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Apple
                  socialButton(
                    onPressed: () {
                      showMessage('Apple chưa được tích hợp');
                    },
                    child: const Icon(
                      Icons.apple,
                      color: Colors.black,
                      size: 23,
                    ),
                  ),

                  // GitHub
                  socialButton(
                    onPressed: () {
                      showMessage('GitHub chưa được tích hợp');
                    },
                    child: const Icon(
                      Icons.code,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),

                  // Twitter
                  socialButton(
                    onPressed: () {
                      showMessage('Twitter chưa được tích hợp');
                    },
                    child: const Text(
                      '♥',
                      style: TextStyle(color: Color(0xFF1DA1F2), fontSize: 22),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
