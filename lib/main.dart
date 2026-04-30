import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const AarogyKendraApp());
}

class AarogyKendraApp extends StatelessWidget {
  const AarogyKendraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AarogyKendra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A7A52)),
        useMaterial3: true,
      ),
      home: const LoginScreen(), // Opens login page directly
    );
  }
}
