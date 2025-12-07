import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/language_service.dart';

class ResumeDayBottomSheet extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback? onResume;

  const ResumeDayBottomSheet({
    super.key,
    required this.selectedDate,
    this.onResume,
  });

  // Translations
  static final Map<String, Map<String, String>> _translations = {
    'English': {
      'resumeMealsTitle': 'Resume Meals For The Day?',
      'resumeMealsDescription': 'Your meal plan will resume for',
      'resumeMealsDescription2': '. Meals will be prepared and delivered as usual.',
      'resume': 'RESUME',
    },
    'Arabic': {
      'resumeMealsTitle': 'استئناف الوجبات لهذا اليوم؟',
      'resumeMealsDescription': 'ستستأنف خطة وجباتك لـ',
      'resumeMealsDescription2': '. سيتم تحضير الوجبات وتسليمها كالمعتاد.',
      'resume': 'استئناف',
    },
  };

  static String _getText(String key) {
    final languageService = LanguageService();
    return _translations[languageService.currentLanguage]?[key] ??
        _translations['English']![key]!;
  }

  static bool get _isRTL => LanguageService().isRTL;

  static String _formatDate(DateTime date) {
    if (_isRTL) {
      final monthsAr = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      return '${monthsAr[date.month - 1]} ${date.day}';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFFFF6B35),
                  size: 40,
                ),
                Positioned(
                  top: 24,
                  child: SvgPicture.asset(
                    'assets/svg/resume.svg',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Title
          Text(
            _getText('resumeMealsTitle'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          RichText(
            textAlign: TextAlign.center,
            textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
            text: TextSpan(
              style: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 14,
              ),
              children: [
                TextSpan(text: _getText('resumeMealsDescription')),
                TextSpan(
                  text: ' (${_formatDate(selectedDate)})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: _getText('resumeMealsDescription2')),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Resume button
          GestureDetector(
            onTap: () {
              if (onResume != null) {
                onResume!();
              }
              Navigator.of(context).pop();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF3A3A3A),
                  width: 1,
                ),
              ),
              child: Text(
                _getText('resume'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void show({
    required BuildContext context,
    required DateTime selectedDate,
    VoidCallback? onResume,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ResumeDayBottomSheet(
        selectedDate: selectedDate,
        onResume: onResume,
      ),
    );
  }
}

