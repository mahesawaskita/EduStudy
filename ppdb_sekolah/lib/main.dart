
import 'package:flutter/material.dart';
import 'screen/login_screen.dart';

void main() {
  runApp(const PPDBApp());
}

class PPDBApp extends StatelessWidget {
  const PPDBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPDB Sekolah',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
