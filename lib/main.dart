import 'package:flutter/material.dart';
import 'package:my_app/screens/register_screen.dart';
import 'screens/register_screen.dart';

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
      home: const RegisterScreen(),
    );
  }
}
