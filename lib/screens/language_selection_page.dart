import 'package:flutter/material.dart';
import 'login_page.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Language Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
                ),
                child: const Icon(
                  Icons.translate,
                  color: Color(0xFFFF6B35),
                  size: 40,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                'Choose Your Language',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Subtitle
              const Text(
                'Select your preferred language for the app, you can adjust it later as well.',
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Language Options
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // English Option
                    _buildLanguageOption(
                      'English',
                      'EN',
                      '🇺🇸',
                      'English',
                      selectedLanguage == 'English',
                    ),
                    const Divider(
                      color: Color(0xFF3A3A3A),
                      height: 1,
                      thickness: 1,
                    ),
                    // Arabic Option
                    _buildLanguageOption(
                      'عربي',
                      'AR',
                      '🇰🇼',
                      'Arabic',
                      selectedLanguage == 'Arabic',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Continue Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFE55A2B)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to login screen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'CONTINUE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Legal Text
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(text: 'By continuing you agree to our\n'),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' | '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    String languageName,
    String languageCode,
    String flagEmoji,
    String languageKey,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedLanguage = languageKey;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Flag Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3A3A3A),
              ),
              child: Center(
                child: Text(
                  flagEmoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Language Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    languageCode,
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Radio Button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFF9E9E9E),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
