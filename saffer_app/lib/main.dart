import 'package:flutter/material.dart';
// import 'package:saffer_app/pages/map_page/main_map.dart';

// import 'package:saffer_app/pages/uid_list_view.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:saffer_app/pages/splash_screen.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter is ready before async calls

  await Supabase.initialize(
    url: 'https://putmfvonnimjvavnnbwm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB1dG1mdm9ubmltanZhdm5uYndtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMxMDUzNjksImV4cCI6MjA1ODY4MTM2OX0.b54SsGdG42iqwQCcioAPqP-Qli2ixtwPe6_hU8t9GPQ',
  );
  
  


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const MainMap(),
      home: SplashScreen(),
    
      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(201, 217, 237, 1), //have changed the seed color
          primary: const Color.fromRGBO(42, 42, 42, 1),
          secondary: Color.fromRGBO(201, 217, 237, 1),
        ),
        textTheme: const TextTheme(
          // Customize your text styles here if needed
          titleLarge: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,fontFamily: "AlbertSans"),
          titleMedium: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,fontFamily:"AlbertSans"),
          titleSmall: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,fontFamily: "AlbertSans"),
          labelSmall: TextStyle(fontSize: 15,fontFamily: "AlbertSans",fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
