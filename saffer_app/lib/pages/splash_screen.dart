import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:saffer_app/pages/uid_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:saffer_app/global/global_assets.dart' as global;
import 'package:saffer_app/pages/uid_page.dart';
import 'package:saffer_app/student/parent_signup.dart';
 // import your UID list page

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

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
    _animationController.forward(); // Start splash animation

    final prefs = await SharedPreferences.getInstance();

    final user = Supabase.instance.client.auth.currentUser;

    // Wait for the splash animation to finish
    await Future.delayed(_animationController.duration!);

    if (!mounted) return;

    if (user == null) {
      // User not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => UserSignUp()),
      );
      return;
    }

    // User logged in, get phone (if needed)
    final phone = user.phone;

  global.setPhoneNumber(phone.toString());
  print(global.phone_number);
    // Fetch user_linked_uids from user_data table
    try {
      final response = await Supabase.instance.client
          .from('user_data')
          .select('user_linked_uids')
          .eq('user_id', user.id)
          .single();

      final List<dynamic> linkedUids = response['user_linked_uids'];

      if (linkedUids.isEmpty) {
        // No UID saved → show initial UID page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UIDPage()),
        );
      } else {
        // UID(s) exist → show UID list page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UidListPage()),
        );
      }
    } catch (error) {
      // Handle fetch error (fallback to UIDPage)
      debugPrint('Error fetching user_linked_uids: $error');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UIDPage()),
      );
    }
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
