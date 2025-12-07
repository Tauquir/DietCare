import 'package:flutter/material.dart';
import '../services/language_service.dart';

class MealDetailWidget extends StatelessWidget {
  final String title;
  final String description;
  final int calories;
  final int protein; // in grams
  final int carbs; // in grams
  final int fat; // in grams
  final String? imageUrl;
  final VoidCallback? onClose;
  final VoidCallback? onAddMeals;

  const MealDetailWidget({
    super.key,
    required this.title,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.imageUrl,
    this.onClose,
    this.onAddMeals,
  });

  // Translations
  static final Map<String, Map<String, String>> _translations = {
    'English': {
      'protein': 'Protein',
      'carbs': 'Carbs',
      'fat': 'Fat',
      'kcal': 'kcal',
      'addMeals': 'ADD MEALS',
    },
    'Arabic': {
      'protein': 'بروتين',
      'carbs': 'كربوهيدرات',
      'fat': 'دهون',
      'kcal': 'سعر حراري',
      'addMeals': 'إضافة وجبات',
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
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.45; // Top portion for image

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Top Section - Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: Stack(
              children: [
                // Meal Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          width: double.infinity,
                          height: imageHeight,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder(imageHeight);
                          },
                        )
                      : _buildImagePlaceholder(imageHeight),
                ),
                // Close Button (X icon in top right)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  right: _isRTL ? null : 16,
                  left: _isRTL ? 16 : null,
                  child: GestureDetector(
                    onTap: onClose ?? () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Section - Information Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                          ),
                          const SizedBox(height: 12),
                          // Description
                          Text(
                            description,
                            style: const TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 14,
                              height: 1.4,
                            ),
                            textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                          ),
                          const SizedBox(height: 20),
                          // Nutritional Information Block
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF3A3A3A),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              children: [
                                // Calories with flame icon
                                Row(
                                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department,
                                      color: Color(0xFFFF722D),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$calories ${_getText('kcal')}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                // Green vertical separator (after calories)
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 20),
                                // Protein
                                _buildMacroItem(_getText('protein'), '${protein}g'),
                                const SizedBox(width: 20),
                                // Blue vertical separator
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 20),
                                // Carbs
                                _buildMacroItem(_getText('carbs'), '${carbs}g'),
                                const SizedBox(width: 20),
                                // Blue vertical separator
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 20),
                                // Fat
                                _buildMacroItem(_getText('fat'), '${fat}g'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // ADD MEALS Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF722D), Color(0xFFB34712)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              onPressed: onAddMeals,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                _getText('addMeals'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
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
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: _isRTL ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: _isRTL ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: const Color(0xFF2A2A2A),
      child: const Center(
        child: Icon(
          Icons.restaurant,
          color: Color(0xFF9E9E9E),
          size: 60,
        ),
      ),
    );
  }

  /// Show as a modal bottom sheet
  static void showAsBottomSheet({
    required BuildContext context,
    required String title,
    required String description,
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
    String? imageUrl,
    VoidCallback? onAddMeals,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.6; // Image height based on width (60% of screen width)
    final contentHeight = 320.0; // Fixed content height
    final bottomSheetHeight = imageHeight + contentHeight;
    final maxHeight = screenHeight * 0.75; // Max 75% of screen height
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: bottomSheetHeight > maxHeight ? maxHeight : bottomSheetHeight,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Section - Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: imageHeight,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholderForBottomSheet(imageHeight);
                          },
                        )
                      : _buildImagePlaceholderForBottomSheet(imageHeight),
                ),
                // Close Button (X icon in top right)
                Positioned(
                  top: 16,
                  right: _isRTL ? null : 16,
                  left: _isRTL ? 16 : null,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Bottom Section - Information Panel
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                        // Title
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                        ),
                        const SizedBox(height: 12),
                        // Description
                        Text(
                          description,
                          style: const TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 14,
                            height: 1.4,
                          ),
                          textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                        // Nutritional Information Block
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF3A3A3A),
                              width: 1,
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Calories with flame icon
                                Row(
                                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department,
                                      color: Color(0xFFFF722D),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$calories ${_getText('kcal')}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                // Green vertical separator (after calories)
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 16),
                                // Protein
                                _buildMacroItemForBottomSheet(_getText('protein'), '${protein}g'),
                                const SizedBox(width: 16),
                                // Blue vertical separator
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 16),
                                // Carbs
                                _buildMacroItemForBottomSheet(_getText('carbs'), '${carbs}g'),
                                const SizedBox(width: 16),
                                // Blue vertical separator
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 16),
                                // Fat
                                _buildMacroItemForBottomSheet(_getText('fat'), '${fat}g'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // ADD MEALS Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF722D), Color(0xFFB34712)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: onAddMeals,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _getText('addMeals'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
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
    );
  }

  static Widget _buildImagePlaceholderForBottomSheet(double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: const Color(0xFF2A2A2A),
      child: const Center(
        child: Icon(
          Icons.restaurant,
          color: Color(0xFF9E9E9E),
          size: 60,
        ),
      ),
    );
  }

  static Widget _buildMacroItemForBottomSheet(String label, String value) {
    return Column(
      crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: _isRTL ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: _isRTL ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }

  /// Show as a full screen dialog
  static void showAsFullScreen({
    required BuildContext context,
    required String title,
    required String description,
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
    String? imageUrl,
    VoidCallback? onAddMeals,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealDetailWidget(
          title: title,
          description: description,
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
          imageUrl: imageUrl,
          onAddMeals: onAddMeals,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}

