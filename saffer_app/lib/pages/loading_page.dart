
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Make sure this imports the global map

class LoadingPage extends StatefulWidget {
  final String bucketName;
  final List<String> paths; // ✅ Multiple paths
  final VoidCallback onDataLoaded;

  const LoadingPage({
    super.key,
    required this.bucketName,
    required this.paths,
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
    _loadAllPaths();
  }

  void _initAnimation() {
    _animationController = AnimationController(vsync: this);
  }

  Future<void> _loadAllPaths() async {
    try {
      final client = Supabase.instance.client;

      for (final path in widget.paths) {
        final response = await client.storage
            .from(widget.bucketName)
            .list(path: path);

        for (final file in response) {
          final fullPath = '$path/${file.name}';
          final publicUrl = client.storage
              .from(widget.bucketName)
              .getPublicUrl(fullPath);

          // Store in global map
          
        }
      }

      await Future.delayed(const Duration(seconds: 1)); // Optional wait

      if (mounted) {
        setState(() => _dataLoaded = true);
        widget.onDataLoaded();
      }
    } catch (e) {
      print("Error loading Supabase paths: $e");
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
