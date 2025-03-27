import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:saffer_app/sign_upPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Start animation
    _animationController.forward();

    // Navigate to SignUpPage after 4 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFDEF6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular logo with gradient color
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], // Purple to blue gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  "S", // Example letter inside the circle
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // App title
            const Text(
              "SAFAR",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            // Tagline
            const Text(
              "No more Suffer",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 30),

            // Lottie Animation
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Lottie.asset(
                'assets/animations/splash_screen.json',
                fit: BoxFit.contain,
                repeat: false,
                controller: _animationController, // Connect controller
              ),
            ),
          ],
        ),
      ),
    );
  }
}

