import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoConnectivity extends StatefulWidget {
  const NoConnectivity({super.key});

  @override
  State<NoConnectivity> createState() => _NoConnectivityState();
}

class _NoConnectivityState extends State<NoConnectivity> with TickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SAFAR",style: Theme.of(context).textTheme.titleMedium,),centerTitle: true,backgroundColor:Theme.of(context).colorScheme.primary,),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Lottie Animation
            Lottie.asset(
              'assets/animations/no_internet.json',
              controller: _animationController,
              onLoaded: (composition) {
                _animationController
                  ..duration = composition.duration
                  ..repeat(); // Loop the animation
              },
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              "Check Your Internet Connectivity",
              
            ),
            const SizedBox(height: 10),
            Text(
              "Try Again",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
