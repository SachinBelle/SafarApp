import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoadingPage extends StatefulWidget {
  final String bucketName;
  final String path;
  final VoidCallback onDataLoaded;

  const LoadingPage({
    super.key,
    required this.bucketName,
    required this.path,
    required this.onDataLoaded,
  });

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _loadDataFromSupabase();
  }

  void _initAnimation() {
    _animationController = AnimationController(vsync: this);
  }

  Future<void> _loadDataFromSupabase() async {
    try {
      final response = await Supabase.instance.client.storage
          .from(widget.bucketName)
          .list(path: widget.path);

      // Simulate extra load time if needed
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        widget.onDataLoaded(); // Navigate or update state
      }

      setState(() => _dataLoaded = true);
    } catch (e) {
      print("Error loading from Supabase: $e");
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 150,
              child: Lottie.asset(
                'assets/animations/loding_page.json',
                controller: _animationController,
                onLoaded: (composition) {
                  _animationController
                    ..duration = composition.duration
                    ..repeat();
                },
                fit: BoxFit.contain,
              ),
            ),
            Text(
              "SAFAR",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 48),
            ),
            Text(
              "No more Suffer",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 30),
            if (!_dataLoaded)
              const CircularProgressIndicator(
                color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }
}
