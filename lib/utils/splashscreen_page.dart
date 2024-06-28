import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import '../Home/homepage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSplashScreen(
        backgroundColor: Theme.of(context).colorScheme.background,
        splashIconSize: 250,
        duration: 1500,
        splash: Lottie.asset('assets/animation/Animation - 1713900595763.json'),
        nextScreen: const HomePage(),
      ),
    );
  }
}
