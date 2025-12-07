import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'language_selection_page.dart';
import 'main_page.dart';
import '../services/auth_storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthenticationAndNavigate();
  }

  Future<void> _checkAuthenticationAndNavigate() async {
    // Wait for splash screen display (3 seconds)
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    // Check if user is authenticated
    final isAuthenticated = await AuthStorageService.isAuthenticated();
    
    if (mounted) {
      if (isAuthenticated) {
        // User is logged in, navigate to main page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        // User is not logged in, navigate to language selection page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Calculate responsive sizes based on screen width
    final logoSize = screenWidth * 0.4; // 40% of screen width
    final textWidth = screenWidth * 0.6; // 60% of screen width
    final textHeight = (textWidth * 39) / 218; // Maintain aspect ratio
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Primary dark background from color palette
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            SvgPicture.asset(
              'assets/svg/logo.svg',
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
            ),
            // Spacing between logo and text
            SizedBox(height: screenHeight * 0.04), // 4% of screen height
            // Text SVG
            SvgPicture.asset(
              'assets/svg/text.svg',
              width: textWidth,
              height: textHeight,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
