import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'language_selection_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to language selection page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 640,
        height: 1382,
        decoration: const BoxDecoration(
          color: Color(0xFF1B1B1B), // #1B1B1B
        ),
        child: Stack(
          children: [
            // Logo positioned at specific coordinates
            Positioned(
              top: 332,
              left: 119.53,
              child: Opacity(
                opacity: 1,
                child: Container(
                  width: 161.48046875,
                  height: 162.58837890625,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF5504).withOpacity(0.0),
                        blurRadius: 25.13,
                        spreadRadius: 0.63,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    'assets/newlogo.svg',
                    width: 161.48046875,
                    height: 162.58837890625,
                  ),
                ),
              ),
            ),
            // Text "soaraat" - will need positioning attributes
            const Positioned(
              top: 520, // Approximate position below logo, adjust as needed
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'soaraat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    height: 1.0, // Exact line height to match letter height
                    letterSpacing: 0.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
