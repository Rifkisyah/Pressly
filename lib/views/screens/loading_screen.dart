import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pressly/views/screens/main_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _showLoading = false;
  bool _moveToTopLeft = false;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _showLoading = true);
    });

    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _moveToTopLeft = true);
    });

    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final logoAsset = theme.isDarkMode
        ? 'assets/images/logo_app_dark_theme.png'
        : 'assets/images/logo_app_light_theme.png';

    const double initialLogoWidth = 150;
    const double finalLogoWidth = 110;

    final double initialLogoHeight = initialLogoWidth;
    final double finalLogoHeight = finalLogoWidth;
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final statusBar = media.padding.top;

    const double finalLeft = 16.0;
    final double finalTop = statusBar + (kToolbarHeight - finalLogoHeight) / 2;

    final double startLeft = (screenWidth - initialLogoWidth) / 2;
    final double startTop = (screenHeight - initialLogoHeight) / 2;

    const moveDuration = Duration(milliseconds: 700);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: moveDuration,
            curve: Curves.easeOutCubic,
            left: _moveToTopLeft ? finalLeft : startLeft,
            top: _moveToTopLeft ? finalTop : startTop,
            child: AnimatedContainer(
              duration: moveDuration,
              curve: Curves.easeOutCubic,
              width: _moveToTopLeft ? finalLogoWidth : initialLogoWidth,
              height: _moveToTopLeft ? finalLogoHeight : initialLogoHeight,

              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: -50.0, end: 0.0),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value, 0),
                    child: Opacity(
                      opacity: (1 - (value.abs() / 50)).clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  logoAsset,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          if (!_moveToTopLeft)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 200),
                  AnimatedOpacity(
                    opacity: _showLoading ? 1 : 0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    child: AnimatedScale(
                      scale: _showLoading ? 1 : 0.6,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      child: const SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
