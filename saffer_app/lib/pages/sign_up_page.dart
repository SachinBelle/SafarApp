import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:saffer_app/student/parent_signup.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFCFDEF6),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 80,
                child: Image.asset('assets/Avatars/logo3.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Sign Up\nAs",
                      style: TextStyle(
                        fontSize: 48,
                        fontFamily: 'AlbertSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SignUpOption(
                      icon_url: "assets/Avatars/studentParent.webp",
                      label: "Student/Parent",
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 500,
                            ),
                            reverseTransitionDuration: Duration(
                              milliseconds: 200,
                            ), // Disable transition when going back
                            pageBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                            ) {
                              return FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                                child: UserSignUp(),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    SignUpOption(
                      icon_url: "assets/Avatars/busDriver.png",
                      label: "Transport Operator",
                      onTap: () {
                       
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Lottie.network(
'https://putmfvonnimjvavnnbwm.supabase.co/storage/v1/object/public/assets/Animations/Busa.json',                  
                  width: double.infinity,
                  height: screenHeight * 0.3,
                  fit: BoxFit.contain,
                   frameRate: FrameRate.max,
                    repeat: true,
                    animate: true,
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
  final String icon_url;
  final String label;
  final VoidCallback onTap;

  const SignUpOption({
    super.key,
    required this.icon_url,
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
                icon_url,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              label,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'AlbertSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
