import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/constants/app_colors.dart';
import '../../res/routes/routes_name.dart';
import '../../services/shared_pref_service.dart';
import 'components/animated_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800), // faster overall
    );

    // Logo zoom animation (0 → 1 scale)
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkLogin() async {
    final token = await SharedPrefService.getPref('token');

    debugPrint('Token => $token');

    Navigator.pushReplacementNamed(context, RoutesName.signInScreen);

    if (token != null && token.toString().isNotEmpty) {
      // Navigator.pushReplacementNamed(
      //   context,
      //   RoutesName.bottomNavigationBarScreen,
      // );
    } else {
      // Navigator.pushReplacementNamed(context, RoutesName.onboardingScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
        Brightness.light, // Android: light icons (white)
        statusBarBrightness:
        Brightness.dark, // iOS: dark background = light (white) text
        systemNavigationBarColor: AppColors.secondaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔥 Logo Zoom Animation
            ScaleTransition(
              scale: _logoScaleAnimation,
              child: Image.asset(
                'assets/icons/app_icon.png',
                height: 200,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),

            /// 🚀 Text Slide Animation
            AnimatedWordsText(
              onFinished: () {
                _checkLogin(); // 👈 NOW CALLED AFTER ANIMATION
              },
            ),

            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
