import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:saffer_app/pages/UserSignUp.dart';

class Initialuserpage extends StatefulWidget {
  const Initialuserpage({super.key});

  @override
  State<Initialuserpage> createState() => _InitialuserpageState();
}

class _InitialuserpageState extends State<Initialuserpage> {
    bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: const Color(0xFFCFDEF6),
     
        
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.only(left: 22.5, top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 150, // Slightly reduced height
                        width: 200, // Slightly reduced width
                        child: Image.asset('assets/logo/safarword.png'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 10),
                      const Text(
                        "Sign Up \nAs",
                        style: TextStyle(
                          fontSize: 48,
                          fontFamily: 'AlbertSans',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                       SizedBox(height: screenHeight*0.03,),
                      SignUpOption(
                        icon_url: "assets/Avatars/studentParent.webp",
                        label: "Student/Parent",
                        onTap: () {
                          if(isChecked){
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
                                  child: UserSignUp (),
                                );
                              },
                            ),
                          );
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 1),backgroundColor:const Color.fromARGB(255, 180, 204, 244),content: Center(child: Text("Accept the terms and conditons and privacy policy to \nSign in",style: TextStyle(color: Colors.black,fontFamily: "AlbertSans",fontSize: 14,fontWeight: FontWeight.w600),))));
                          }
                        },
                      ),
                     
                    ],
                  ),
                ),
                SizedBox(height: screenHeight*0.05,),

                SizedBox(

                  width: double.infinity,
                  child: Lottie.asset(
                    'assets/animations/Bus_animation.json',
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [
               Checkbox(value: isChecked,activeColor: Colors.green,checkColor: Colors.white, onChanged:(bool? value){
                setState((){
                  isChecked = value ?? false;
                });
              }),
             
Expanded(
  child: RichText(
    text: TextSpan(
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: Colors.black, // Default text color
          ),
      children: [
        const TextSpan(text: 'I accept the '),
        TextSpan(
          text: 'Terms and Conditions',
          style: const TextStyle(
            color: Colors.green,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // TODO: Navigate to Terms page
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text("Terms and Conditions tapped")),
              // );
            },
        ),
        const TextSpan(text: ' and '),
        TextSpan(
          text: 'Privacy Policy',
          style: const TextStyle(
            color: Colors.green,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text("Privacy Policy tapped")),
              // );
            },
        ),
        const TextSpan(text: ' of Safar App!'),

      ],
    ),
  ),
),
          ],

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
