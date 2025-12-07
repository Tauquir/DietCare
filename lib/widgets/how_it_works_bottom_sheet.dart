import 'package:flutter/material.dart';
import '../services/language_service.dart';

class HowItWorksBottomSheet extends StatelessWidget {
  const HowItWorksBottomSheet({super.key});

  // Translations
  static final Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'How It Works?',
      'subtitle': 'Simple steps to start your healthy routine.',
      'step1Title': 'Pick Your Plan',
      'step1Description': 'Find one that fits your goals.',
      'step2Title': 'Customize & Schedule',
      'step2Description': 'Choose your start date and preferences.',
      'step3Title': 'Fresh Meals Delivered',
      'step3Description': 'Enjoy ready-to-eat, chef-made meals.',
      'step4Title': 'Track & Adjust Anytime',
      'step4Description': 'Pause or resume whenever you need.',
    },
    'Arabic': {
      'title': 'كيف يعمل؟',
      'subtitle': 'خطوات بسيطة لبدء روتينك الصحي.',
      'step1Title': 'اختر خطتك',
      'step1Description': 'ابحث عن واحدة تناسب أهدافك.',
      'step2Title': 'خصص وجدول',
      'step2Description': 'اختر تاريخ البدء وتفضيلاتك.',
      'step3Title': 'وجبات طازجة يتم توصيلها',
      'step3Description': 'استمتع بوجبات جاهزة للأكل من الشيف.',
      'step4Title': 'تتبع وضبط في أي وقت',
      'step4Description': 'أوقف أو استأنف متى احتجت.',
    },
  };

  static String _getText(String key) {
    final languageService = LanguageService();
    return _translations[languageService.currentLanguage]?[key] ?? 
           _translations['English']![key]!;
  }

  static bool get _isRTL => LanguageService().isRTL;

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const HowItWorksBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and close button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getText('title'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getText('subtitle'),
                          style: const TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Divider
            const Divider(
              color: Color(0xFF3A3A3A),
              height: 1,
              thickness: 1,
            ),
            // Steps list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  _buildStep(
                    icon: Icons.star,
                    title: _getText('step1Title'),
                    description: _getText('step1Description'),
                  ),
                  const SizedBox(height: 20),
                  _buildStep(
                    icon: Icons.calendar_today,
                    title: _getText('step2Title'),
                    description: _getText('step2Description'),
                  ),
                  const SizedBox(height: 20),
                  _buildStep(
                    icon: Icons.restaurant,
                    title: _getText('step3Title'),
                    description: _getText('step3Description'),
                  ),
                  const SizedBox(height: 20),
                  _buildStep(
                    icon: Icons.tune,
                    title: _getText('step4Title'),
                    description: _getText('step4Description'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon with gradient background
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF6B35),
                Color(0xFFFF8C5A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        // Title and description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

