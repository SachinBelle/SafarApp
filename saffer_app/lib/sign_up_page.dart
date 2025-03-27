import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:saffer_app/student/parent_signup.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    // final double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFCFDEF6),

        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              SizedBox(
                height: 80,
                child: Image.asset('assets/photos/logo3.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 0,
                  bottom: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "As",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Sign-Up Options
                    SignUpOption(
                      icon: "assets/photos/studentParent.webp",
                      label: "Student/Parent",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return UserSignUp();
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    SignUpOption(
                      icon: "assets/photos/busDriver.png",
                      label: "Transport Operator",
                      onTap: () {
                        print("Driver Sign Up");
                      },
                    ),
                  ],
                ),
              ),
              // Reduced space

              // Bus Animation
              SizedBox(
                width: double.infinity,
                child: Lottie.asset(
                  'assets/animations/Busa.json',
                  width: double.infinity, // 80% of screen width
                  height:
                      screenHeight *
                      0.3, // 30% of screen height// Adjusted for better visibility
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpOption extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const SignUpOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(141, 255, 255, 255),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                icon,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              label,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
