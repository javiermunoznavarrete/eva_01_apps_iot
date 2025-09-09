import 'package:flutter/material.dart';
import 'package:eva_01_apps_iot/login_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login App',
      home: LoginScreen(),
    );
  }
}
