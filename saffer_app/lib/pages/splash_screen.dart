import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:saffer_app/pages/uid_page.dart';
import 'package:saffer_app/student/parent_signup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  String? phone;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _initializeSplash();
  }

  Future<void> _initializeSplash() async {
    // Start animation
    _animationController.forward();

    // Fetch phone number from Supabase Auth session
    final user = Supabase.instance.client.auth.currentUser;
    phone = user?.phone;

    // Wait until animation is done
    await Future.delayed(_animationController.duration!);

    // Navigate based on phone
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => phone != null ? const UIDPage() : UserSignUp(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
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
            // Safar logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo/slogo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "SAFAR",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              "No more Suffer",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            // Lottie animation
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Lottie.asset(
                'assets/animations/splash_screen.json',
                fit: BoxFit.contain,
                controller: _animationController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
