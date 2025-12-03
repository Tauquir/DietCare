import 'package:flutter/material.dart';
import '../services/language_service.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final LanguageService _languageService = LanguageService();

  // Translations
  Map<String, Map<String, String>> _translations = {
    'English': {
      'favourites': 'Favourites',
      'protein': 'Protein',
      'carbs': 'Carbs',
      'fats': 'Fats',
      'kcal': 'kcal',
    },
    'Arabic': {
      'favourites': 'المفضلة',
      'protein': 'بروتين',
      'carbs': 'كربوهيدرات',
      'fats': 'دهون',
      'kcal': 'كيلو',
    },
  };

  String _getText(String key) {
    return _translations[_languageService.currentLanguage]?[key] ?? _translations['English']![key]!;
  }

  bool get _isRTL => _languageService.isRTL;

  // Track favorite status by index
  Set<int> _favoriteIndices = {0, 1, 2, 3, 4};

  // Mock favorite meals data
  List<Map<String, dynamic>> get _allMeals {
    if (_isRTL) {
      return [
        {
          'id': 0,
          'title': 'طبق دجاج مشوي غني بالطاقة',
          'description': 'وعاء صحي من الدجاج والخضروات والبيض والحبوب.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': true,
        },
        {
          'id': 1,
          'title': 'طبق دجاج مشوي غني بالطاقة',
          'description': 'وعاء صحي من الدجاج والخضروات والبيض والحبوب.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': true,
        },
        {
          'id': 2,
          'title': 'طبق دجاج مشوي غني بالطاقة',
          'description': 'وعاء صحي من الدجاج والخضروات والبيض والحبوب.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': true,
        },
        {
          'id': 3,
          'title': 'طبق دجاج مشوي غني بالطاقة',
          'description': 'وعاء صحي من الدجاج والخضروات والبيض والحبوب.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': true,
        },
        {
          'id': 4,
          'title': 'طبق دجاج مشوي غني بالطاقة',
          'description': 'وعاء صحي من الدجاج والخضروات والبيض والحبوب.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': true,
        },
      ];
    } else {
      return [
        {
          'id': 0,
          'title': 'Grilled Chicken Power Bowl',
          'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': true,
        },
        {
          'id': 1,
          'title': 'Grilled Chicken Power Bowl',
          'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': true,
        },
        {
          'id': 2,
          'title': 'Grilled Chicken Power Bowl',
          'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': true,
        },
        {
          'id': 3,
          'title': 'Grilled Chicken Power Bowl',
          'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': true,
        },
        {
          'id': 4,
          'title': 'Grilled Chicken Power Bowl',
          'description': 'A wholesome bowl of chicken, veggies, eggs & grains.',
          'calories': '145',
          'protein': '21g',
          'carbs': '21g',
          'fats': '21g',
          'isFavorite': true,
        },
      ];
    }
  }

  // Get only favorited meals
  List<Map<String, dynamic>> get _favoriteMeals {
    return _allMeals.asMap().entries
        .where((entry) => _favoriteIndices.contains(entry.key))
        .map((entry) => entry.value)
        .toList();
  }

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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            _isRTL ? Icons.arrow_forward : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _getText('favourites'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _favoriteMeals.isEmpty
          ? Center(
              child: Text(
                _isRTL ? 'لا توجد وجبات مفضلة' : 'No favorite meals',
                style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: _favoriteMeals.length,
              itemBuilder: (context, index) {
                final meal = _favoriteMeals[index];
                final mealId = meal['id'] as int;
                return _buildMealCard(meal, mealId);
              },
            ),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // Text content (left in LTR, right in RTL)
          Expanded(
            child: Column(
              crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Text(
                  meal['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meal['description'],
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: _isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Color(0xFFFF6B35),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${meal['calories']} ${_getText('kcal')}',
                      style: const TextStyle(
                        color: Color(0xFFFF6B35),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Nutritional breakdown
                Row(
                  mainAxisAlignment: _isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    _buildNutritionLabel(_getText('protein'), meal['protein'], Colors.green),
                    Container(
                      width: 1,
                      height: 16,
                      color: const Color(0xFF3A3A3A),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    _buildNutritionLabel(_getText('carbs'), meal['carbs'], Colors.orange),
                    Container(
                      width: 1,
                      height: 16,
                      color: const Color(0xFF3A3A3A),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    _buildNutritionLabel(_getText('fats'), meal['fats'], Colors.blue),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Image (right in LTR, left in RTL)
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Color(0xFF9E9E9E),
                  size: 40,
                ),
              ),
              Positioned(
                top: 8,
                right: _isRTL ? null : 8,
                left: _isRTL ? 8 : null,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      // Remove from favorites
                      _favoriteIndices.remove(index);
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionLabel(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label ',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

