import 'package:flutter/material.dart';
import 'package:springr/utils/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Start the effect chain and navigate
    _startAnimationAndNavigation();
  }

  // Use async/await to ensure the navigation happens after the animation
  Future<void> _startAnimationAndNavigation() async {
    // After a short delay, start the fade-in effect
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _opacity = 1.0);

    // Hold logo for a few seconds
    await Future.delayed(const Duration(seconds: 2));

    // Check if the widget is still mounted
    if (!mounted) return;

    // Start the fade-out effect
    setState(() => _opacity = 0.0);

    // Wait for the fade-out to complete
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Navigate to the login page
    Navigator.of(context).pushReplacementNamed(
      RouteGenerator.loginPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 800),
          child: Image.asset(
            'assets/jpg/ussh.jpg',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}