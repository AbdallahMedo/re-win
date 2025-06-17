import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../login/presentation/view/login_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Lottie.asset("assets/images/Animation - 1739359869620.json"),
        nextScreen:LoginView(),
      backgroundColor: Colors.white,
      splashIconSize: 250,
      duration: 3000,
      animationDuration:const Duration(seconds: 2),
    );
  }
}
