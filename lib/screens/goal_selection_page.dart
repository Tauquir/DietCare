import 'package:flutter/material.dart';
import '../services/language_service.dart';
import 'gender_dob_page.dart';

class GoalSelectionPage extends StatefulWidget {
  const GoalSelectionPage({super.key});

  @override
  State<GoalSelectionPage> createState() => _GoalSelectionPageState();
}

class _GoalSelectionPageState extends State<GoalSelectionPage> {
  final LanguageService _languageService = LanguageService();
  int _selectedGoalIndex = 0; // 0: Lose Weight, 1: Maintain Weight, 2: Gain Muscle, 3: Gain Muscle/Lose Weight

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'What\'s your Goal?',
      'subtitle': 'Set your goal so we can design meals that match your lifestyle.',
      'loseWeight': 'Lose Weight',
      'maintainWeight': 'Maintain Weight',
      'gainMuscle': 'Gain Muscle',
      'gainMuscleLoseWeight': 'Gain Muscle/Lose Weight',
      'next': 'NEXT',
    },
    'Arabic': {
      'title': 'ما هو هدفك؟',
      'subtitle': 'حدد هدفك حتى نتمكن من تصميم وجبات تناسب أسلوب حياتك.',
      'loseWeight': 'خسارة الوزن',
      'maintainWeight': 'الحفاظ على الوزن',
      'gainMuscle': 'بناء العضلات',
      'gainMuscleLoseWeight': 'بناء العضلات / خسارة الوزن',
      'next': 'التالي',
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
        child: Column(
          children: [
            // Top section with back button and progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isRTL ? Icons.arrow_forward : Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Progress bar
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: _isRTL ? Alignment.centerRight : Alignment.centerLeft,
                        widthFactor: 0.25, // 25% progress
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Title and subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    _getText('title'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getText('subtitle'),
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                      height: 1.4,
                    ),
                    textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Goal selection cards
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  _buildGoalCard(0, _getText('loseWeight')),
                  const SizedBox(height: 16),
                  _buildGoalCard(1, _getText('maintainWeight')),
                  const SizedBox(height: 16),
                  _buildGoalCard(2, _getText('gainMuscle')),
                  const SizedBox(height: 16),
                  _buildGoalCard(3, _getText('gainMuscleLoseWeight')),
                ],
              ),
            ),
            // NEXT button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GenderDobPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFF722D),
                        Color(0xFF99441B),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B35).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getText('next'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(int index, String title) {
    final isSelected = _selectedGoalIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGoalIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFFFF6B35),
                  width: 2,
                )
              : null,
        ),
        child: Row(
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            // Text
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: _isRTL ? TextAlign.right : TextAlign.left,
              ),
            ),
            const SizedBox(width: 16),
            // Placeholder for illustration (you can replace with actual images)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.fitness_center,
                color: Color(0xFF9E9E9E),
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

