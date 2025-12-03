import 'package:flutter/material.dart';
import '../screens/menu_page.dart';
import '../screens/subscription_page.dart';
import '../services/language_service.dart';

class MealPlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl; // For backend image URL
  final String protein;
  final String carbs;
  final String kcal; // e.g., "1000 - 1200"
  final List<String> mealComponents;
  final String price;
  final VoidCallback? onViewMenu;
  final VoidCallback? onSubscribe;

  const MealPlanCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.protein,
    required this.carbs,
    required this.kcal,
    required this.mealComponents,
    required this.price,
    this.onViewMenu,
    this.onSubscribe,
  });

  // Translations
  static final Map<String, Map<String, String>> _translations = {
    'English': {
      'protein': 'Protein',
      'carbs': 'Carbs',
      'kcal': 'Kcal',
      'includes': 'INCLUDES',
      'viewMenu': 'VIEW MENU',
      'startingFrom': 'STARTING FROM',
      'subscribe': 'SUBSCRIBE',
    },
    'Arabic': {
      'protein': 'بروتين',
      'carbs': 'كربوهيدرات',
      'kcal': 'سعر حراري',
      'includes': 'يتضمن',
      'viewMenu': 'عرض القائمة',
      'startingFrom': 'يبدأ من',
      'subscribe': 'اشترك',
    },
  };

  static String _getText(String key) {
    final languageService = LanguageService();
    return _translations[languageService.currentLanguage]?[key] ?? _translations['English']![key]!;
  }

  static bool get _isRTL => LanguageService().isRTL;

  @override
  Widget build(BuildContext context) {
    final cardWidth = 289.0;
    final cardHeight = 343.0;
    final imageWidth = 288.0;
    final imageHeight = 138.0;
    final borderRadiusTopLeft = 12.56;
    final borderRadiusTopRight = 17.59;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF212121), // Dark grey background matching image
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Image Banner
          Container(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadiusTopLeft),
                topRight: Radius.circular(borderRadiusTopRight),
              ),
            ),
            child: Stack(
              children: [
                // Women image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadiusTopLeft),
                    topRight: Radius.circular(borderRadiusTopRight),
                  ),
                  child: Image.asset(
                    'assets/women.png',
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: imageWidth,
                        height: imageHeight,
                        color: const Color(0xFF3A3A3A),
                      );
                    },
                  ),
                ),
                // Gradient overlay for text readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadiusTopLeft),
                        topRight: Radius.circular(borderRadiusTopRight),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Title overlay
                Positioned(
                  bottom: 10,
                  left: 14,
                  right: 14,
                  child: Column(
                    crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                    // Nutritional Information
                    Container(
                      width: 257.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.28),
                      ),
                      child: Row(
                        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildNutritionItem(_getText('protein'), protein),
                          const SizedBox(width: 16),
                          _buildNutritionItem(_getText('carbs'), carbs),
                          const SizedBox(width: 16),
                          // Kcal in a distinct box with more padding
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A3A3A),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _getText('kcal'),
                                  style: const TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  kcal,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Includes Section with red dot and VIEW MENU
                    Row(
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            Text(
                              _getText('includes'),
                              style: const TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: onViewMenu ?? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MenuPage(),
                              ),
                            );
                          },
                          child: Text(
                            _isRTL ? '< ${_getText('viewMenu')}' : '${_getText('viewMenu')} >',
                            style: const TextStyle(
                              color: Color(0xFFFF7622),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Meal Components - Two rows with two items each
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // First row: Breakfast and Main Course
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (mealComponents.isNotEmpty && mealComponents.length >= 1)
                              Expanded(child: _buildMealComponent(mealComponents[0])),
                            if (mealComponents.length >= 2)
                              Expanded(child: _buildMealComponent(mealComponents[1])),
                          ],
                        ),
                        // Second row: Soup & Snack and Salad & Drink
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (mealComponents.length >= 3)
                              Expanded(child: _buildMealComponent(mealComponents[2])),
                            if (mealComponents.length >= 4)
                              Expanded(child: _buildMealComponent(mealComponents[3])),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Pricing and Subscribe Button
                    Row(
                      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getText('startingFrom'),
                              style: const TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 8,
                              ),
                              textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              price,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: onSubscribe ?? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SubscriptionPage(),
                              ),
                            );
                          },
                          child: Container(
                            width: 111.0,
                            height: 38.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.13),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFA43B08), // #A43B08
                                  Color(0xFFFF702A), // #FF702A
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _getText('subscribe'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Column(
      crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
        const SizedBox(height: 2),
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

  Widget _buildMealComponent(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 12,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: _isRTL ? TextAlign.right : TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

