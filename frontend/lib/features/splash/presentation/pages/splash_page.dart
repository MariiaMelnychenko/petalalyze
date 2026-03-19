import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:petalalyze/core/routing/app_navigation.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

/// Splash screen with spinning flower animation and Petalalyze branding
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 4420), () {
      if (mounted) {
        const HomeRoute().go(context);
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F8F0), // soft mint top
              Color(0xFFD4EDE4), // sage
              Color(0xFFB8E0D4), // aqua mint
              Color(0xFFA3D4C4), // deeper sage
            ],
            stops: [0.0, 0.35, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              RotationTransition(
                turns: _rotationController,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset(
                    AppAssets.flowerLoading,
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                  ),
                ),
              ),
              const Text(
                'Petalalyze',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: AppColors.mediumDarkGreen,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
