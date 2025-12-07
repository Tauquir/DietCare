import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/language_service.dart';

class LanguageSelectionDialog extends StatefulWidget {
  const LanguageSelectionDialog({super.key});

  @override
  State<LanguageSelectionDialog> createState() => _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  final LanguageService _languageService = LanguageService();
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  void _loadCurrentLanguage() {
    setState(() {
      _selectedLanguage = _languageService.currentLanguage;
    });
  }

  Future<void> _selectLanguage(String language) async {
    await _languageService.setLanguage(language);
    setState(() {
      _selectedLanguage = language;
    });
    // Close dialog after selection
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = _languageService.isRTL;
    
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isRTL ? 'تغيير اللغة' : 'Change Language',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
                    languageName: 'English',
                    languageCode: 'EN',
                    iconPath: 'assets/svg/english.svg',
                    languageKey: 'English',
                    isSelected: _selectedLanguage == 'English',
                    onTap: () => _selectLanguage('English'),
                  ),
                  // Divider
                  const Divider(
                    color: Color(0xFF3A3A3A),
                    height: 1,
                    thickness: 1,
                  ),
                  // Arabic Option
                  _buildLanguageOption(
                    languageName: 'عربي',
                    languageCode: 'AR',
                    iconPath: 'assets/svg/arabic.svg',
                    languageKey: 'Arabic',
                    isSelected: _selectedLanguage == 'Arabic',
                    onTap: () => _selectLanguage('Arabic'),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildLanguageOption({
    required String languageName,
    required String languageCode,
    required String iconPath,
    required String languageKey,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          children: [
            // Language Icon
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3A3A3A),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
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
                  color: isSelected ? const Color(0xFFFF6B35) : Colors.white,
                  width: 2,
                ),
                color: isSelected ? const Color(0xFFFF6B35) : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

