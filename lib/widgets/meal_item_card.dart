import 'package:flutter/material.dart';
import '../services/language_service.dart';

class MealItemCard extends StatelessWidget {
  final String title;
  final String description;
  final int calories;
  final int protein; // in grams
  final int carbs; // in grams
  final int fats; // in grams
  final String? imageUrl;
  final VoidCallback? onTap;

  const MealItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.imageUrl,
    this.onTap,
  });

  // Translations
  static final Map<String, Map<String, String>> _translations = {
    'English': {
      'protein': 'Protein',
      'carbs': 'Carbs',
      'fats': 'Fats',
      'kcal': 'kcal',
    },
    'Arabic': {
      'protein': 'بروتين',
      'carbs': 'كربوهيدرات',
      'fats': 'دهون',
      'kcal': 'سعر حراري',
    },
  };

  static String _getText(String key) {
    final languageService = LanguageService();
    return _translations[languageService.currentLanguage]?[key] ?? 
           _translations['English']![key]!;
  }

  static bool get _isRTL => LanguageService().isRTL;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A), // Dark background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Section - Text Information
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 13,
                        height: 1.3,
                      ),
                      textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    // Calorie Count with Flame Icon
                    Row(
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: const Color(0xFFFF7622),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$calories ${_getText('kcal')}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Macronutrient Breakdown
                    Row(
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildMacroItem(_getText('protein'), '${protein}g'),
                        // Vertical separator
                        Container(
                          width: 1,
                          height: 20,
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          color: const Color(0xFF3A3A3A),
                        ),
                        _buildMacroItem(_getText('carbs'), '${carbs}g'),
                        // Vertical separator
                        Container(
                          width: 1,
                          height: 20,
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          color: const Color(0xFF3A3A3A),
                        ),
                        _buildMacroItem(_getText('fats'), '${fats}g'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Right Section - Meal Image
            Container(
              width: 120,
              height: 120,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF3A3A3A),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                      )
                    : _buildPlaceholder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroItem(String label, String value) {
    return Column(
      crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          textAlign: _isRTL ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          textAlign: _isRTL ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 120,
      height: 120,
      color: const Color(0xFF3A3A3A),
      child: const Icon(
        Icons.restaurant,
        color: Color(0xFF9E9E9E),
        size: 40,
      ),
    );
  }
}

