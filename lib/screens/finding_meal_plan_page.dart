import 'package:flutter/material.dart';
import '../services/language_service.dart';

class FindingMealPlanPage extends StatefulWidget {
  const FindingMealPlanPage({super.key});

  @override
  State<FindingMealPlanPage> createState() => _FindingMealPlanPageState();
}

class _FindingMealPlanPageState extends State<FindingMealPlanPage> {
  final LanguageService _languageService = LanguageService();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'Finding Your Best Meal Plan...',
      'subtitle': 'Set your goal so we can design meals that match your lifestyle.',
    },
    'Arabic': {
      'title': 'جاري العثور على أفضل خطة وجبات لك...',
      'subtitle': 'حدد هدفك حتى نتمكن من تصميم وجبات تناسب نمط حياتك.',
    },
  };

  String _getText(String key) {
    return _translations[_languageService.currentLanguage]?[key] ?? _translations['English']![key]!;
  }

  bool get _isRTL => _languageService.isRTL;

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    // Navigate to next screen after a delay (simulating loading)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // TODO: Navigate to the next screen (e.g., home page or meal plan results)
        // Navigator.of(context).pushReplacement(...);
      }
    });
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Stack(
          children: [
            // Background geometric shapes
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFF6B35).withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF99441B).withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Orange 'S' shape
                        CustomPaint(
                          size: const Size(80, 80),
                          painter: _SPainter(),
                        ),
                        // White circle (head)
                        Positioned(
                          top: 10,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      _getText('title'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      _getText('subtitle'),
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 14,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the 'S' shape logo (resembling a person with arms raised)
class _SPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF6B35)
      ..style = PaintingStyle.fill
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Draw the S shape as a curved path resembling a person with raised arms
    final path = Path();
    
    // Top curve (left arm raised)
    path.moveTo(size.width * 0.2, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.05, size.height * 0.2, size.width * 0.1, size.height * 0.35);
    
    // Middle curve (body)
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.5, size.width * 0.3, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width * 0.5, size.height * 0.65);
    
    // Bottom curve (right arm raised)
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.8, size.width * 0.7, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.85, size.width * 0.85, size.height * 0.7);
    
    // Complete the S shape back
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.55, size.width * 0.65, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width * 0.5, size.height * 0.35);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.2, size.width * 0.3, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.15, size.width * 0.2, size.height * 0.15);
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

