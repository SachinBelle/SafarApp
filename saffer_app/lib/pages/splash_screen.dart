import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:saffer_app/pages/InitialUserPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saffer_app/pages/uid_pages/uid_page.dart';
import 'package:saffer_app/pages/uid_pages/uid_list_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _initializeSplash();
  }

  Future<void> _initializeSplash() async {
    _animationController.forward();

    final prefs = await SharedPreferences.getInstance();
    final user = supabase.auth.currentUser;

    await Future.delayed(_animationController.duration!);
    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const  Initialuserpage()));
      return;
    }

    try {
      final userData = await supabase
          .from("user_data")
          .select('user_name, phone_number, user_linked_uid')
          .eq('user_uid', user.id)
          .maybeSingle();

      if (userData == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const  Initialuserpage ()));
        return;
      }

      // Optional: You can store these locally if needed
      final userName = userData['user_name'] as String?;
      final phoneNumber = userData['phone_number'] as String?;
      final List<String> uidList = (userData['user_linked_uid'] as List?)?.map((e) => e.toString()).toList() ?? [];

      if (uidList.isEmpty) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UIDPage()));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UidListPage(uidList: uidList,)),
        );
      }
    } catch (error) {
      debugPrint('Error fetching user data: $error');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UIDPage()));
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
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(0, 255, 253, 253),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Center(
                child: ClipOval(
                  child: Image.asset('assets/logo/slogo.png', fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text("SAFAR", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black)),
            const Text("No more Suffer", style: TextStyle(fontSize: 17, color: Colors.black)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Lottie.asset('assets/animations/splash_screen.json', controller: _animationController),
            ),
          ],
        ),
      ),
    );
  }
}
