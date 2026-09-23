import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() {
  runApp(const PhoneStoreApp());
}

class PhoneStoreApp extends StatelessWidget {
  const PhoneStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cửa hàng điện thoại',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xffeeeeee),
      ),
      home: const WelcomeScreen(),
    );
  }
}
