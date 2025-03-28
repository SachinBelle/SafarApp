import 'package:flutter/material.dart';
import 'package:saffer_app/splash_screen.dart';
// import 'package:saffer_app/student/parent_signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 247, 248, 249),
          primary: const Color(0xFFCFDEF6),
        ),
      ),
    );
  }
}
