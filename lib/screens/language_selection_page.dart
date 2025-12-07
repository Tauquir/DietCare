import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import 'main_page.dart';
import '../services/language_service.dart';
import '../services/auth_storage_service.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  final LanguageService _languageService = LanguageService();
  String selectedLanguage = 'English';

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'title': 'Choose Your Language',
      'subtitle': 'Select your preferred language for the app, you can adjust it later as well.',
      'continue': 'CONTINUE',
      'terms': 'By continuing you agree to our\n',
      'termsLink': 'Terms of Service',
      'privacyLink': 'Privacy Policy',
    },
    'Arabic': {
      'title': 'اختر لغتك',
      'subtitle': 'اختر اللغة المفضلة للتطبيق، يمكنك تعديلها لاحقًا أيضًا.',
      'continue': 'متابعة',
      'terms': 'بالمتابعة، أنت توافق على\n',
      'termsLink': 'شروط الخدمة',
      'privacyLink': 'سياسة الخصوصية',
    },
  };

  String _getText(String key) {
    return _translations[selectedLanguage]?[key] ?? _translations['English']![key]!;
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
    _languageService.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {
      selectedLanguage = _languageService.currentLanguage;
    });
  }

  Future<void> _loadCurrentLanguage() async {
    await _languageService.loadLanguage();
    setState(() {
      selectedLanguage = _languageService.currentLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B), // Dark background matching design
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
            // Language Icon positioned at specific coordinates
            Positioned(
              top: 125,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 1,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/language.svg',
                    width: 125,
                    height: 125,
                  ),
                ),
              ),
            ),
            // Title "Choose Your Language" positioned directly below the icon
            Positioned(
              top: 275,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 1,
                child: Center(
                  child: Text(
                    _getText('title'),
                    style: GoogleFonts.onest(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: 0.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // Subtitle positioned at specific coordinates
            Positioned(
              top: 316,
              left: 43,
              child: Opacity(
                opacity: 1,
                child: SizedBox(
                  width: 315,
                  height: 38,
                  child: Center(
                    child: Text(
                      _getText('subtitle'),
                      style: GoogleFonts.onest(
                        color: const Color(0xFF7A7A7A),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 20.73 / 15, // line-height / font-size
                        letterSpacing: 0.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            // Language Options positioned at specific coordinates
            Positioned(
              top: 396,
              left: 16,
              child: Opacity(
                opacity: 1,
                child: SizedBox(
                  width: 370,
                  height: 166,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // English Option
                          _buildLanguageOption(
                            'English',
                            'EN',
                            'assets/svg/english.svg',
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
                            'assets/svg/arabic.svg',
                            'Arabic',
                            selectedLanguage == 'Arabic',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Continue Button positioned at specific coordinates
            Positioned(
              top: 607,
              left: 16,
              child: Opacity(
                opacity: 1,
                child: SizedBox(
                  width: 370,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF722D), Color(0xFFB34712)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(25.13),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Save selected language
                        await _languageService.setLanguage(selectedLanguage);
                        
                        // Check if user is authenticated
                        final isAuthenticated = await AuthStorageService.isAuthenticated();
                        
                        if (!mounted) return;
                        
                        // Navigate based on authentication status
                        if (isAuthenticated) {
                          // User is logged in, navigate to home page
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const MainPage()),
                          );
                        } else {
                          // User is not logged in, navigate to login screen
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.13),
                        ),
                      ),
                      child: Text(
                        _getText('continue'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Legal Text positioned at specific coordinates
            Positioned(
              top: 782,
              left: 58,
              child: Opacity(
                opacity: 1,
                child: SizedBox(
                  width: 285,
                  height: 42,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getText('terms').replaceAll('\n', ''),
                        style: const TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                          children: [
                            TextSpan(
                              text: _getText('termsLink'),
                            ),
                            TextSpan(
                              text: ' | ',
                              style: const TextStyle(
                                color: Color(0xFF9E9E9E),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            TextSpan(
                              text: _getText('privacyLink'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
    String iconPath,
    String languageKey,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () async {
        // Change language immediately
        await _languageService.setLanguage(languageKey);
        setState(() {
          selectedLanguage = languageKey;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.5),
        child: Row(
          children: [
            // Language Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3A3A3A),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
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
